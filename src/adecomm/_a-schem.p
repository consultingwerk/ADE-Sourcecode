/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* a-schema.p - all fields of _dtype = int(pi_dtype) into comma-sep-list.
   _dtype = 0 or * = wildcards (i.e. all types)

DICTDB must be pointing to SDBNAME(pi_dbname).

Note that this returns _Label, not _Col-label, as the first choice.
_y-schem.p returns _Col-label.

History: 07/10/98 D. McMann Changed Find to FOR EACH to be able to verify
                            _owner with DBVERSION.
*/

DEFINE INPUT  PARAMETER pi_dbname AS CHARACTER NO-UNDO. /* ldbname */
DEFINE INPUT  PARAMETER pi_table  AS CHARACTER NO-UNDO. /* tablename */
DEFINE INPUT  PARAMETER pi_dtype  AS CHARACTER NO-UNDO. /* dtype listing */
DEFINE OUTPUT PARAMETER po_labels AS CHARACTER INITIAL "" NO-UNDO.
DEFINE OUTPUT PARAMETER po_fields AS CHARACTER INITIAL "" NO-UNDO.

DEFINE VARIABLE ix  AS INTEGER   NO-UNDO.
DEFINE VARIABLE lbl AS CHARACTER NO-UNDO.

FIND DICTDB._Db
  WHERE DICTDB._Db._Db-name =
    (IF DBTYPE(pi_dbname) = "PROGRESS":u THEN ? ELSE pi_dbname)
  NO-LOCK NO-ERROR.
IF NOT AVAILABLE DICTDB._Db THEN RETURN.

FOR EACH DICTDB._File OF DICTDB._Db WHERE DICTDB._File._File-name = pi_table 
            AND CAN-DO(DICTDB._File._Can-Read,USERID(pi_dbname)) NO-LOCK:
  IF INTEGER(DBVERSION("DICTDB")) > 8 AND 
     (DICTDB._File._Owner <> "PUB" AND DICTDB._File._Owner <> "_FOREIGN") THEN 
    RELEASE DICTDB._File. 
  ELSE LEAVE.  
END.
IF NOT AVAILABLE DICTDB._File THEN RETURN.

/*--------------------------------------------------------------------------*/

ASSIGN
  pi_dtype = (IF pi_dtype = "0":u OR pi_dtype = "*":u THEN
                "1,2,3,4,5":u
              ELSE
                pi_dtype
              )
  po_fields = ""
  po_labels = "".

FOR EACH DICTDB._Field OF DICTDB._File
  WHERE CAN-DO(pi_dtype,STRING(DICTDB._Field._dtype)) 
   AND CAN-DO(DICTDB._Field._Can-Read,USERID(pi_dbname)) NO-LOCK
  BY DICTDB._Field._Field-name:

  lbl = (IF DICTDB._Field._Label = ? OR DICTDB._Field._Label = ""
         THEN DICTDB._Field._Field-name ELSE DICTDB._Field._Label).

  IF DICTDB._Field._Extent = 0 THEN
    ASSIGN
      po_fields = po_fields + (IF po_fields = "" THEN "" ELSE ",":u)
		+ DICTDB._Field._Field-name
      po_labels = po_labels + (IF po_labels = "" THEN "" ELSE ",":u)
		+ lbl.
  ELSE
    DO ix = 1 TO DICTDB._Field._Extent:
      ASSIGN
	po_fields = po_fields + (IF po_fields = "" THEN "" ELSE ",":u)
		  + DICTDB._Field._Field-name + "[" + STRING(ix) + "]"
	po_labels = po_labels + (IF po_labels = "" THEN "" ELSE ",":u)
		  + lbl.
    END.
END.

RETURN.

/* a-schema.p - end of file */


