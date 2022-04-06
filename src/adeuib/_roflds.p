/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _roflds.p

Description:
   Fill a selection list with RowObject fields.  The fields will be ordered 
   by order #.
Input Parameters:
   p_List   - Handle of the selection list widget to add to.
              p_List:private-data is a comma seperated list of items
              NOT to be added. OR no items if the entire table-list is
              to be added.
   p_query  - Char Recid to identify the _BC records.
Output Parameters:
  p_Stat   - Set to TRUE if list is retrieved (even if there were no fields
      	      this is successful).  Set to FALSE, if user doesn't have access
      	      to fields.
Author: Ross Hunter
Date Created: 10/98

Modified:

----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_List         AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p_query        AS CHARACTER     NO-UNDO.
DEFINE OUTPUT PARAMETER p_Stat         AS LOGICAL       NO-UNDO.

DEFINE VARIABLE query-rec AS INTEGER          NO-UNDO.

DEFINE VARIABLE FldList AS CHARACTER NO-UNDO.

{adeuib/brwscols.i}

/************************* Inline code section ***************************/

/* Convert the p_query string to a real RECID */
query-rec = INTEGER(p_query).

FOR EACH _BC WHERE _BC._x-recid = query-rec:
  FldList = FldList + (IF FldList EQ "":U THEN "":U ELSE ",":U) + _BC._DISP-NAME.
END.

ASSIGN p_Stat            = TRUE
       p_List:LIST-ITEMS = FldList.
       
