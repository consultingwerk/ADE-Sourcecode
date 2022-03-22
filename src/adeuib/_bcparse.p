/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _bcparse.p

Description:
    Procedure called by _gendefs.p to parse a browse column calculated field
    and return a list of DB fields from a particular table used in the
    calulated field.

    It was necessary to separate this out so that _gendefs won't need to be 
    connected to a DB to function.

Preprocessor Parameters:

Input Parameters:
   _BC-rec  - RECID of calculated field
   t-db     - Database of fields
   t-tbl    - Table fo fields
   
Output Parameters:
   ostring  - Output string

Author: D. Ross Hunter

Date Created: 1995

---------------------------------------------------------------------------- */
{adeuib/sharvars.i}    /* UIB shared variables                               */
{adeuib/uniwidg.i}     /* Universal widget definitions                       */
{adeuib/brwscols.i}    /* Browse Column Temp-table                           */

DEFINE INPUT  PARAMETER _BC-rec AS RECID                              NO-UNDO.
DEFINE INPUT  PARAMETER t-db    AS CHARACTER                          NO-UNDO.
DEFINE INPUT  PARAMETER t-tbl   AS CHARACTER                          NO-UNDO.
DEFINE OUTPUT PARAMETER ostring AS CHARACTER                          NO-UNDO.


DEF VAR i              AS INTEGER                                     NO-UNDO.
DEF VAR is-fld         AS LOGICAL                                     NO-UNDO.
DEF VAR pot-fld        AS CHARACTER                                   NO-UNDO.
DEF VAR tmp_str        AS CHARACTER                                   NO-UNDO.


FIND _BC WHERE RECID(_BC) = _BC-rec.

tmp_str = TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(_BC._DISP-NAME,
              "[":U, " ":U), "]":U, " ":U), "(":U, " ":U),
              ")":U, " ":U), ",":U, " ":U)).
DO i = 1 TO NUM-ENTRIES(tmp_str, " ":U):
  ASSIGN pot-fld = ENTRY(i, tmp_str, " ":u)  /* Potential field */
         is-fld  = NO.
  IF NUM-ENTRIES(pot-fld,".":U) = 3 THEN DO:
    IF ENTRY(1,pot-fld,".":U) = t-db AND ENTRY(2,pot-fld,".":U) = t-tbl
    THEN DO:
        is-fld  = yes.
        IF _suppress_dbname OR CAN-DO(_tt_log_name, t-db) THEN
          pot-fld = ENTRY(2,pot-fld,".":U) + ".":U + ENTRY(3,pot-fld,".":U).
    END.   
  END. /* If db.tbl.fld */
  ELSE IF NUM-ENTRIES(pot-fld,".":U) = 2 THEN DO:
    IF ENTRY(1,pot-fld,".":U) = t-tbl THEN is-fld = yes.
  END. /* IF tbl.fld */
  ELSE IF NUM-ENTRIES(pot-fld,".":U) = 1 THEN DO:
    IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
      FIND DICTDB._FILE WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
                              DICTDB._FILE._FILE-NAME = t-tbl NO-LOCK NO-ERROR.
    ELSE
      FIND DICTDB._FILE WHERE DICTDB._FILE._FILE-NAME = t-tbl NO-LOCK NO-ERROR.

    IF AVAILABLE DICTDB._FILE THEN DO:
      FIND DICTDB._FIELD OF DICTDB._FILE 
           WHERE DICTDB._FIELD._FIELD-NAME = pot-fld NO-LOCK NO-ERROR.
      IF AVAILABLE DICTDB._FIELD THEN is-fld = yes.
    END.  /* IF found the table record */
  END. /* IF fld */
  /* ELSE forget it!  We tried */
  IF is-fld THEN ostring = ostring + pot-fld + CHR(10) + "      ":U.
END. /* DO i = 1 to num-entries */

