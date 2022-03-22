/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _lstnav.p (List 1st letter Navigation)

Description:
   This file should be called for each selection list that should
   support first letter navigation.  It should be called from an
   ANY-PRINTABLE trigger, like:

      on ANY-PRINTABLE of lst in frame x
      	 run adecomm/_lstnav.p (INPUT lst:HANDLE in frame foo, 
      	       	     	       OUTPUT found_val).

Input Parameters:
   p_List   - Widget handle of the select list.

Output Parameters:
   p_val    - Set to ? if no match was found.  Otherwise, it is set
      	      to the list value which matched the first letter search.

Author: Laura Stern

Date Created: 04/13/93 

----------------------------------------------------------------------------*/

define input  parameter p_List as widget-handle NO-UNDO.
define output parameter p_val as char  	        NO-UNDO init ?.

define var key       as char	 NO-UNDO. /* Key value just typed */
define var curr_val  as char     NO-UNDO. /* Current value of select-list */
define var lst_val   as char	 NO-UNDO. /* Value of a select list item */
define var ix        as integer  NO-UNDO. /* Loop index */
define var start     as integer  NO-UNDO. /* Index into select list */
define var found     as logical  NO-UNDO. /* Did we find a prefix match? */

/* Set curr_val to the current selection or the 1st item */
curr_val = p_List:screen-value.
if curr_val = ? then curr_val = p_List:entry(1).

/* return if list is empty */
if curr_val = ? then return. 

/* See if we can find a prefix match between the one character the user
   just typed and a select list item.  If there is no match then the
   selection is left as is.
*/
assign
   key = CHR(LASTKEY)
   found = false
   /* Start searching from the item after the currently selected item */
   start = p_List:lookup(curr_val) + 1.  

do ix = start to p_List:num-items while NOT found:
   lst_val = p_List:ENTRY(ix).
   if lst_val BEGINS key then
      found = true.
end.

/* If we haven't found a match yet, wrap around to the top of the
   list and continue searching.  Don't bother ever checking against
   the item we're already on, hence the "- 2". */
do ix = 1 to start - 2 while NOT found:
   lst_val = p_List:ENTRY(ix).
   if lst_val BEGINS key then
      found = true.
end.

if found then
do:
   /* set selection and make sure this item will be in view */
   p_List:screen-value = lst_val.
   run adecomm/_scroll.p (INPUT p_List, INPUT lst_val).
   p_val = lst_val.
end.






