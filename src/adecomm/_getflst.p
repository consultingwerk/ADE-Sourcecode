/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _getflst.p

Description:
   Fill a selection list with fields.  The fields will be ordered either
   alphabetically or by order #.  The database that these fields are stored 
   in must be aliased to DICTDB before this routine is called.

Input Parameters:
   p_List   - Handle of the selection list widget to add to.
         p_List:private-data is a comma seperated list of items
         NOT to be added. OR no items if the entire table-list is
         to be added.

   p_Recid  - The recid of the table to which these fields belong.
   p_usetbl = If not ? THEN use this table name instead of the actual.
   p_Alpha  - TRUE if order should be alphabetical, FALSE if we want to
               order by the _Order value of the field.
   p_Items  - List of fields to included in list.  If this parameter is
              blank, then just the field name is put in the list.  Currently
              the parameter can have the following values in any order:
              1 - just the field name - then is the default
              2 - tablename.fldname
              3 - dbname.tablename.fldname
              T - Name of table containing the field
              F - Format
   p_DType  - The data type to screen for.  If this is ?, then don't screen.
               Otherwise this must be either
                    "character"
                    "date"
                    "decimal"
                    "integer"
                    "logical"
                    "recid"
   p_ExpandExtent  - 0  field name only for extent field
                     1  extented field name changed to fieldName[1-N].
                     2  extented field names are expanded

  p_CallBack  - The name of the program to run for security of a "" to blow
              this callback off.


Output Parameters:
   p_Stat   - Set to TRUE if list is retrieved (even if there were no fields
               this is successful).  Set to FALSE, if user doesn't have access
               to fields.

Author: Laura Stern, Warren Bare

Date Created: 06/02/92 

----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_List         AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p_Recid        AS RECID         NO-UNDO.
DEFINE INPUT  PARAMETER p_usetbl       AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p_Alpha        AS LOGICAL       NO-UNDO.
DEFINE INPUT  PARAMETER p_Items        AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p_DType        AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p_ExpandExtent AS INTEGER       NO-UNDO.
DEFINE INPUT  PARAMETER p_CallBack     AS CHARACTER     NO-UNDO.
DEFINE OUTPUT PARAMETER p_Stat         AS LOGICAL       NO-UNDO.

DEFINE BUFFER bField FOR DICTDB._Field.

DEFINE VARIABLE v_dbname  AS CHARACTER      NO-UNDO.
DEFINE VARIABLE err       AS LOGICAL        NO-UNDO.
DEFINE VARIABLE widg      AS widget-handle  NO-UNDO.
DEFINE VARIABLE v_ItemCnt AS INTEGER          NO-UNDO.
DEFINE VARIABLE v_BldLine AS CHARACTER      NO-UNDO.
DEFINE VARIABLE lInclude  AS LOGICAL        NO-UNDO.
DEFINE VARIABLE i         AS INTEGER        NO-UNDO.
DEFINE VARIABLE fName     AS CHARACTER      NO-UNDO.
DEFINE VARIABLE sep       AS CHARACTER      NO-UNDO.

/************************* Inline code section ***************************/

IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
  FIND DICTDB._File WHERE DICTDB._File._FILE-NAME = "_Field":u
                      AND LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0
                     NO-LOCK.

ELSE
  FIND DICTDB._File "_Field":u NO-LOCK.

IF NOT CAN-DO(DICTDB._File._Can-Read,USERID("DICTDB":u)) THEN DO:
  MESSAGE "You do not have permission to see any field information.":t
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  p_Stat = FALSE.
  RETURN.
END.

/* This is where we find other buffer information that may be needed */
FIND DICTDB._File WHERE RECID(DICTDB._FILE) = p_Recid.
FIND DICTDB._DB WHERE RECID(DICTDB._DB) = _File._DB-recid NO-LOCK.

IF p_Items = "" THEN p_Items = "1":u.

v_dbname = IF _db._db-name NE ? THEN _db._db-name ELSE ldbname("DICTDB":u).

ASSIGN
  widg = p_List:parent  /* gives me the group */
  widg = widg:parent.   /* gives me the frame */

RUN adecomm/_setcurs.p ("WAIT":u).

IF p_Alpha THEN DO:
  IF p_DType = ? THEN
    FOR EACH DICTDB.bField 
      WHERE DICTDB.bField._File-Recid = p_Recid 
       AND CAN-DO(DICTDB.bField._Can-Read,USERID("DICTDB":u)) NO-LOCK
      BY DICTDB.bField._Field-Name:
      {adecomm/fldlist.i}
    END.
  ELSE
    FOR EACH DICTDB.bField 
      WHERE DICTDB.bField._File-Recid = p_Recid 
         AND bField._Data-Type = p_DType 
        AND CAN-DO(DICTDB.bField._Can-Read,USERID("DICTDB":u)) NO-LOCK
      BY DICTDB.bField._Field-Name:
      {adecomm/fldlist.i}
    END.
END.
ELSE DO:
  IF p_DType = ? THEN
    FOR EACH DICTDB.bField 
      WHERE DICTDB.bField._File-Recid = p_Recid  
        AND CAN-DO(DICTDB.bField._Can-Read,USERID("DICTDB":u)) NO-LOCK
      BY DICTDB.bField._Order:
      {adecomm/fldlist.i}
    END.
  ELSE
    FOR EACH DICTDB.bField 
      WHERE DICTDB.bField._File-Recid = p_Recid 
        AND bField._Data-Type = p_DType 
        AND CAN-DO(DICTDB.bField._Can-Read,USERID("DICTDB":u)) NO-LOCK
      BY DICTDB.bField._Order:
      {adecomm/fldlist.i}
    END.
END.

RUN adecomm/_setcurs.p ("").
p_Stat = TRUE.

RETURN.

/* _getflst.p - end of file */

