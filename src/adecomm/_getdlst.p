/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _getdlst.p

Description:
   Fill a selection list with SmartData fields.  The fields will be ordered either
   alphabetically or by order #.  
Input Parameters:
   p_List   - Handle of the selection list widget to add to.
              p_List:private-data is a comma seperated list of items
              NOT to be added. OR no items if the entire table-list is
              to be added.
   p_hSmartData  - Handle of the SmartData to which these fields belong.
   p_Alpha  - TRUE if order should be alphabetical, FALSE if we want to
              order by the field order in the temp table. Should default to 
              order for the temp table fields... specially for a browse
              querying the SmartObject
   p_Items  - List of fields to included in list.  If this parameter is
              blank, then just the field name is put in the list.  Currently
              the parameter can have the following values in any order:
              1 - just the field name - this is the default
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
Output Parameters:
  p_Stat   - Set to TRUE if list is retrieved (even if there were no fields
      	      this is successful).  Set to FALSE, if user doesn't have access
      	      to fields.
Author: SLK
Date Created: 02/98
Copied from _getflst.p
Modified:   mm/dd/yyyy  SLK use of dynamic-function instead of get.
            3/16/1998   JEP Assign correct value to fDataType when
                            creating sdoData records.
            01/12/2000  Tomn  Allow for the p_Items value to be a "|" delimited
                              list: The first element being the same as the 
                              original value (fields to include) and the second
                              being an optional table name to use instead of
                              the hard-coded "RowObject" name.
            05/18/2000  BSG  Allow columnDataType to request a qualified field
                             for support of SBOs 
----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_List         AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p_hSmartData        AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p_Alpha        AS LOGICAL       NO-UNDO.
DEFINE INPUT  PARAMETER p_Items        AS CHARACTER     NO-UNDO.
DEFINE INPUT  PARAMETER p_DType        AS CHARACTER     NO-UNDO.
DEFINE OUTPUT PARAMETER p_Stat         AS LOGICAL   	NO-UNDO.
/* DEFINE VARIABLE err       AS LOGICAL        NO-UNDO. */
DEFINE VARIABLE widg        AS widget-handle  NO-UNDO.
DEFINE VARIABLE seq         AS INTEGER        NO-UNDO.
DEFINE VARIABLE v_ItemCnt   AS INTEGER        NO-UNDO.
DEFINE VARIABLE i           AS INTEGER        NO-UNDO.
DEFINE VARIABLE cItems      AS CHARACTER      NO-UNDO.
DEFINE VARIABLE cTable      AS CHARACTER      NO-UNDO.

DEFINE VARIABLE cCurrField  AS CHARACTER      NO-UNDO.
DEFINE VARIABLE cCurrTable  AS CHARACTER      NO-UNDO.

DEFINE VARIABLE FldList AS CHARACTER NO-UNDO.
define variable hColumn         as handle                no-undo.
define variable lDbAware        as logical               no-undo.


DEFINE TEMP-TABLE sdoData NO-UNDO
       FIELD seq       AS INTEGER
       FIELD ftable    AS CHARACTER
       FIELD fname     AS CHARACTER
       FIELD fformat   AS CHARACTER
       FIELD fdatatype AS CHARACTER
     INDEX seq IS PRIMARY seq
     INDEX table-name ftable fname.

/************************* Function Prototypes ***************************/

FUNCTION fieldDataType
  RETURNS CHARACTER
  (INPUT icObject AS CHARACTER,
   INPUT icField AS CHARACTER) FORWARD.


/************************* Inline code section ***************************/

/* If the SmartData object handle is invalid, tell user and return. jep-code */
IF NOT VALID-HANDLE(p_hSmartData) THEN DO:
  MESSAGE "Could not access data field information.":t SKIP(1)
          "The data object is not active."
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  p_Stat = FALSE.
  RETURN.
END.

FldList = dynamic-function("getDataColumns" IN p_hSmartData).
IF FldList = "" OR FldList = ? THEN DO:
  MESSAGE "The data object has no field information.":t
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  p_Stat = FALSE.
  RETURN.
END.

/* Split out the (possible) multiple elements in p_Items and put them in
 * separate variables.
 */
ASSIGN
   cItems = ENTRY(1, p_Items, "|":U)
   cTable = IF NUM-ENTRIES(p_Items, "|":U) > 1 THEN ENTRY(2, p_Items, "|":U) ELSE ?.
/* default to field name. 3 = database.table.field which is not relevant 
 * to a smartData. 2=table.field which is still relevant to a SmartData
 * but the temp table name is hardcoded to rowObject 
 */

IF cItems = "" OR cItems = "3" THEN cItems = "1":U.

/* Give me the parent of the selection list */
ASSIGN widg = p_List:parent       /* gives me the group */
       widg = widg:parent.        /* gives me the frame */

RUN adecomm/_setcurs.p ("WAIT":u).

/* Determine whether this data obejct is a Dataview or SDO */
{get DbAware lDbAware p_hSmartData}.

DO i = 1 to NUM-ENTRIES(FldList):
   cCurrField = ENTRY(i,FldList).
   /* Use qualifer if the field list is qualified (SBOs and DataViews) */
   IF i = 1 THEN 
     cItems = STRING(NUM-ENTRIES(cCurrField,".":U)).

   cCurrTable = IF NUM-ENTRIES(cCurrField,".":U) >= 2 THEN 
                ENTRY(NUM-ENTRIES(cCurrField,".":U) - 1,cCurrField,".":U) 
                ELSE "RowObject":U.
   
   cCurrField = ENTRY(NUM-ENTRIES(cCurrField,".":U),cCurrField,".":U).
       
   IF cTable <> ? THEN 
   do:
       /* If this is a DataView, and a table has been passed to the API
	      via p_Items, then only show the fields that belong to that table.
	    */
       if not lDbAware and cTable ne cCurrTable then
           next.
       else
           cCurrTable = cTable.
   end.    /* table specified */
   
   /* Array fields are not supported for DataViews. We may at some point
      expand the use of the p_Dtype parameter to be able to generically 
      exclude (rather than include) fields on data type, and may add support
      for arrays there.
    */
   if not lDbAware then
   do:
       hColumn = {fnarg ColumnHandle "cCurrTable + '.':u + cCurrField" p_hSmartData}.
       if valid-handle(hColumn) and hColumn:Extent gt 0 then
           next.
   end.    /* db aware */
   
   CREATE sdoData.
   ASSIGN seq               = seq + 1
          sdoData.seq       = seq
          sdoData.fTable    = cCurrTable
          sdoData.fName     = cCurrField.

   /* Get the column data type from the object. If the table is RowObject,
      we're dealing with an SDO and the code doesn't need to qualify the
      field name. Otherwise we need to qualify the field name with the 
      table name (ObjectName in the SBO) so the SBO can go and figure
      out what the data type of the field is. */
   sdoData.fDataType = dynamic-function("columnDataType" IN p_hSmartData, 
                                        INPUT (IF sdoData.fTable = "RowObject":U THEN "":U ELSE sdoData.fTable + ".":U) 
                                              + sdoData.fName).
END.

IF p_Alpha THEN DO:
  IF p_DType = ? THEN
    FOR EACH sdoData BY sdoData.fName:
      p_List:ADD-LAST(IF cItems eq "1" THEN sdoData.fName
                 ELSE IF cItems eq "2" THEN sdoData.fTable + "." + sdoData.fName
                 ELSE sdoData.fName).
    END.
  ELSE
    FOR EACH sdoData WHERE sdoData.fDataType = p_DType BY sdoData.fName:
      p_List:ADD-LAST(IF cItems eq "1" THEN sdoData.fName
                 ELSE IF cItems eq "2" THEN sdoData.fTable + "." + sdoData.fName
                 ELSE sdoData.fName).
    END.
END.
ELSE DO:
  IF p_DType = ? THEN
    FOR EACH sdoData:
      p_List:ADD-LAST(IF cItems eq "1" THEN sdoData.fName
                 ELSE IF cItems eq "2" THEN sdoData.fTable + "." + sdoData.fName
                 ELSE sdoData.fName).
    END.
  ELSE
    FOR EACH sdoData WHERE sdoData.fdataType = p_DType:
       p_List:ADD-LAST(IF cItems eq "1" THEN sdoData.fName
                 ELSE IF cItems eq "2" THEN sdoData.fTable + "." + sdoData.fName
                 ELSE sdoData.fName).
    END.
END.

RUN adecomm/_setcurs.p ("").
p_Stat = TRUE.

RETURN.

/* _getdlst.p - end of file */
