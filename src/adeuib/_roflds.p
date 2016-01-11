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
       
