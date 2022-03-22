/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
