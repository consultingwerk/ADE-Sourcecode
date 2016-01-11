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

File: delitem.p

Description:
   Delete an item from a selection list and reset selection to the spot
   this item inhabited (or if it was at the bottom to the line above that).

Input Parameters:
   p_List - Widget handle of selection list to delete from.
   p_Val  - The value of the item to delete.

Output Parameters:
   p_Cnt  - The number of items left in the list after deletion. 

Author: Laura Stern

Date Created: 02/24/92 

----------------------------------------------------------------------------*/

Define INPUT  PARAMETER p_List as widget-handle NO-UNDO.
Define INPUT  PARAMETER p_Val  as char 	     	NO-UNDO.
Define OUTPUT PARAMETER p_Cnt  as integer    	NO-UNDO.

Define var err as logical NO-UNDO.
Define var num as integer NO-UNDO.
Define var val as char    NO-UNDO.


num = p_List:Lookup(p_Val).	 /* Get position of p_Val in the list */
err = p_List:Delete(p_Val).	 /* Delete the value */
p_Cnt = p_List:Num-Items.	 /* The total # of values after delete */

if p_Cnt > 0 then
do:
   /* adjust num if the deleted item was at the end of the list */
   if num > p_Cnt then	
      num = num - 1.
   val = p_List:Entry(num).   	 /* Get the value at deleted position */
   p_List:screen-value = val.	 /* Reset selection to the same position */
end.
