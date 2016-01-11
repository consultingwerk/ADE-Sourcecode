/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: constraint.i

Description:   
   This file contains the logic for populating a list item.

HISTORY
Author: Kumar Mayur

Date Created:09/25/2011
----------------------------------------------------------------------------*/ 
 
/*------------------------------Triggers--------------------------------*/
 

/*----- ON ANY-PRINTABLE (ASCII) of FILL -----*/
on ANY-PRINTABLE of {&CBFill} in {&Frame}
do:
   define var fill_val  as char	    NO-UNDO. /* Fill-in value */
   define var curr_val  as char     NO-UNDO. /* Current value of select-list */
   define var lst_val   as char	    NO-UNDO. /* Value of a select list item */
   define var ix      	as integer  NO-UNDO. /* Loop index */
   define var start  	as integer  NO-UNDO. /* Index into select list */
   define var found     as logical  NO-UNDO. /* Did we find a prefix match? */
 
   curr_val = {&CBList}:screen-value in {&Frame}.
   if curr_val = ? then return.  /* return if list is empty. */
 
   /* See if we can find a prefix match between the fill-in value,
      including the character the user just typed, and a select list item.
      If there is no match then the selection is left as is.  Otherwise,
      the selection is changed.
      Add the key just typed to get the value to be matched. The last key
      typed won't be in the fill-in yet until we return from this trigger. */
 
   assign
      fill_val = (if SELF:AUTO-ZAP then CHR(LASTKEY) 
      	       	                   else SELF:screen-value + CHR(LASTKEY))
      found = false
      /* Start searching from the currently selected item */
      start = {&CBList}:lookup(curr_val) in {&Frame}.  
 
   do ix = start to {&CBList}:NUM-ITEMS in {&Frame} while NOT found:
      lst_val = {&CBList}:ENTRY(ix) in {&Frame}.
      if lst_val BEGINS fill_val then
         found = true.
   end.
 
   /* If we haven't found a match yet, wrap around to the top of the
      list and continue searching. */
   do ix = 1 to start - 1 while NOT found:
      lst_val = {&CBList}:ENTRY(ix) in {&Frame}.
      if lst_val BEGINS fill_val then
         found = true.
   end.
 
   if found then
   do:
      /* If we found a match other than the one already selected,
      	 set selection and make sure this item's in view.  Then notify
      	 application. */
 
      if lst_val <> curr_val then
      do:
	 {&CBList}:screen-value in {&Frame} = lst_val.
	 run adecomm/_scroll.p (INPUT {&CBList}:HANDLE in {&Frame}, 
			       INPUT lst_val).
 
	 /* Notify application of selection change. Since I can't apply
	    an event to myself (the fill widget), apply to the list */
	 apply "U1" to {&CBList} in {&Frame}.
      end.
   end.
end.
 

