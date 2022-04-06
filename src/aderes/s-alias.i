/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *    Dereference an aliased table name. This code will properly decide 
 *    if the tablename provided is an alias and will dereference the alias 
 *    back to the "real" table.
 *
 *    This fragment requires that j-define.i is provided. It works
 *    with the buffers defined for qbf-rel-tt.  The (hopefully 
 *    desirable) side effect is that qbf-rel-buf2 will change to
 *    contain the record corresponding to the real table name.  If 
 *    p_find is true, qbf-rel-buf will change to contain the record 
 *    containing p_name (which may be an alias).
 *
 *    Input Parameters:
 *
 *        p_name - the table name either table or db.table
 *    	       	   or db.table.field.  The table part may be an alias.
 *        p_find - if TRUE - find the qbf-rel-buf record for this table
 *    	       	   first, otherwise, qbf-rel-buf already contains this
 *    	       	   record.
 *
 *    Output Parameters:
 *        p_realname - The same as p_name except the table part is 
 *    	       	       replaced with the real table name if it was an 
 *    	       	       alias.  This may be the same variable as p_name.
 */

PROCEDURE alias_to_tbname:
   DEFINE INPUT  PARAMETER p_name      AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER p_find      AS LOGICAL   NO-UNDO.
   DEFINE OUTPUT PARAMETER p_realname  AS CHARACTER NO-UNDO.

   DEFINE VARIABLE tbname AS CHARACTER NO-UNDO.

   p_realname = p_name.

   /* If name is db.tbl.field, change it to be just db.tbl */
   IF NUM-ENTRIES(p_name, ".") > 2 THEN   
      tbname = ENTRY(1, p_name, ".") + "." + ENTRY(2, p_name, ".").
   ELSE IF NUM-ENTRIES(p_name, ".") < 2 THEN   
      tbname = LDBNAME(1) + "." + p_name.
   ELSE
      tbname = p_name.

   IF p_find THEN
     {&FIND_TABLE_BY_NAME} tbname NO-ERROR.

   IF AVAILABLE qbf-rel-buf AND qbf-rel-buf.sid <> ? THEN DO:

      /* There's a table alias here.  */
      {&FIND_TABLE2_BY_ID} qbf-rel-buf.sid.

      IF NUM-ENTRIES(p_realname, ".") > 1 THEN   
        ENTRY(2, p_realname, ".") = ENTRY(2, qbf-rel-buf2.tname, ".").
      ELSE  
        p_realname = ENTRY(2, qbf-rel-buf2.tname, ".").
    END.
END.

/* s-alias.i - end of file */

