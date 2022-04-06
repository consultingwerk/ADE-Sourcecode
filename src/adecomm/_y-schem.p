/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _y-schem.p - extract field schema information (see also [as]-schema.p) 

  Modified: 07/10/98 D. McMann Added DBVERSION and _Owner check.

*/

DEFINE INPUT  PARAMETER pi_dbname AS CHARACTER NO-UNDO. /* dbname */
DEFINE INPUT  PARAMETER pi_table  AS CHARACTER NO-UNDO. /* tablename */
DEFINE INPUT  PARAMETER pi_field  AS CHARACTER NO-UNDO. /* fieldname */
DEFINE OUTPUT PARAMETER po_info   AS CHARACTER INITIAL ? NO-UNDO. /* response */

/*
This tables a dbname, tablename and fieldname and returns:

  ? if the field does not exist, or a complex string.

The complex string can be accessed by:

  INTEGER(ENTRY(1,x)) = _dtype
  INTEGER(ENTRY(2,x)) = _Extent
  ENTRY(3,x)          = "y" if any type of index component, "n" otherwise
  ENTRY(4,x)          = "y" is word-index component, "n" otherwise
  ENTRY(5,x)          = "y" is mandatory, "n" otherwise
  ENTRY(2,x,CHR(10))  = _Format
  ENTRY(3,x,CHR(10))  = _Col-label, or _Label, or _Field-name

(The latter is the RESULTS defaults for getting the label of a field
for a report.)
*/

/* dbname,tablename,fieldname can come in pi_dbname+pi_table+pi_field, */
/* or as a combined entries in pi_dbname or pi_dbname+pi_table */
IF NUM-ENTRIES(pi_dbname,".":u) = 3 THEN
  ASSIGN
    pi_field  = ENTRY(3,pi_dbname,".":u)
    pi_table  = ENTRY(2,pi_dbname,".":u)
    pi_dbname = ENTRY(1,pi_dbname,".":u).
IF NUM-ENTRIES(pi_dbname,".":u) = 2 THEN
  ASSIGN
    pi_table  = ENTRY(2,pi_dbname,".":u)
    pi_dbname = ENTRY(1,pi_dbname,".":u).
IF NUM-ENTRIES(pi_table,".":u) = 2 THEN
  ASSIGN
    pi_field = ENTRY(2,pi_table,".":u)
    pi_table = ENTRY(1,pi_table,".":u).

IF LDBNAME(pi_dbname) = ? THEN RETURN.

/* Strip off [n] for array fields. */
IF INDEX(pi_field,"[":u) > 0 THEN
  pi_field = SUBSTRING(pi_field,1,INDEX(pi_field,"[":u) - 1,"CHARACTER":u).

/* if not pointing to correct db, fix situation and call self */
/* recursively.  this will also leave things set for the next */
/* time this guy is called. */
IF LDBNAME("DICTDB":u) <> SDBNAME(pi_dbname) THEN DO:
  CREATE ALIAS "DICTDB":u FOR DATABASE VALUE(SDBNAME(pi_dbname)).
  RUN VALUE(PROGRAM-NAME(1)) (pi_dbname,pi_table,pi_field,OUTPUT po_info).
  RETURN.
END.

/* now point to correct _Db,_File,_Field records */
FIND DICTDB._Db
  WHERE DICTDB._Db._Db-name =
    (IF DBTYPE(pi_dbname) = "PROGRESS":u THEN ? ELSE LDBNAME(pi_dbname))
  NO-LOCK NO-ERROR.
IF NOT AVAILABLE DICTDB._Db THEN RETURN.

IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN DO:
  FIND DICTDB._File OF DICTDB._Db
    WHERE DICTDB._File._File-name = pi_table 
      AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE DICTDB._File THEN RETURN.
END.
ELSE DO:
  FIND DICTDB._File OF DICTDB._Db
    WHERE DICTDB._File._File-name = pi_table NO-LOCK NO-ERROR.
  IF NOT AVAILABLE DICTDB._File THEN RETURN.
END.  

FIND DICTDB._Field OF DICTDB._File
    WHERE DICTDB._Field._Field-name = pi_field NO-LOCK NO-ERROR.
IF NOT AVAILABLE DICTDB._Field THEN RETURN.

po_info = STRING(DICTDB._Field._dtype)
        + ",":u
        + STRING(DICTDB._Field._Extent)
        + ",":u
        + STRING(CAN-FIND(FIRST DICTDB._Index-field OF DICTDB._Field),"y/n":u)
        + ",n,":u
        + STRING(DICTDB._Field._Mandatory,"y/n":u)
        + ",":u
        + CHR(10)
        + DICTDB._Field._Format
        + CHR(10)
        + (IF DICTDB._Field._Col-label <> ? THEN
            DICTDB._Field._Col-label
          ELSE IF DICTDB._Field._Label <> ? THEN
            DICTDB._Field._Label
          ELSE
            DICTDB._Field._Field-name).

/* if word index defined, set that also */
FOR EACH DICTDB._Index-field OF DICTDB._Field NO-LOCK,
  FIRST DICTDB._Index OF DICTDB._Index-field WHERE
    CAN-FIND (DICTDB._Field WHERE DICTDB._Field._Field-name = "_Wordidx")
    AND DICTDB._Index._Wordidx > 0 NO-LOCK:
  ENTRY(4,po_info) = "y":u.
  LEAVE.
END.

RETURN.

/* _y-schem.p - end of file */


