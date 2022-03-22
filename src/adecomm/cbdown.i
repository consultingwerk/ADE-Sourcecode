/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: cbdown.i

Description:
   This file contains both in-line code and trigger code that 
   controls a down-always combo box.  A down-always combo box is one 
   that contains a fill-in field and a selection list where the
   list is always visible.

Arguments:
   &Frame   - The name of the frame that the combo box appears in, 
      	      e.g., "foo".
   &CBFill  - The variable that is the fill-in field part of the
      	      combo box.
   &CBList  - The variable that is the selection list part of the
      	      combo box.
   &CBInit  - The initial value of the combo box.  e.g., if the list
      	      values are known and they are "May","June","July", set
      	      this to ""June"" to have June be selected when the combo
      	      box is first displayed.  If this is set to the null
      	      string, the first item in the list is selected.

Events Generated:
   U1 may be sent to either the fill-in widget or the selection list
   widget when the selection list value has changed.  You must have a
   trigger on both in order to detect this correctly.

How to use this include file:
   This file should be included before the frame is made visible
   but after the FORM definition, if there is one.
   
   None of the combo box pieces need to be enabled by the caller
   but either of them can be.

   The fill-in and list variables need to be included in the
   FORM but only the fill-in needs to be given a position.


Author: Laura Stern

Date Created: 03/06/92 

----------------------------------------------------------------------------*/


/*------------------------------Triggers--------------------------------*/

/*----- LEAVE of FILL -----*/
on leave of {&CBFill} in {&Frame}
do:
   define var lst_val as char NO-UNDO.

   /* If the value entered in the fill-in prefix-matches a value in the
      select list, reset it's value to be the full selection list value. 
      Otherwise, we'll leave it alone. */
   lst_val = {&CBList}:screen-value in {&Frame}.
   if lst_val BEGINS SELF:screen-value then
      {&CBFill}:screen-value in {&Frame} = lst_val.
end.


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
      typed won't be in the fill-in yet until we return from this trigger.
   */
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
      	 application. 
      */
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


/*----- SELECTION of LIST ITEM -----*/
on value-changed of {&CBList} in {&Frame}
do:
   /* Reflect selection in fill-in. */
   if SELF:screen-value = ? then
      {&CBFill}:screen-value in {&Frame} = "".
   else 
      {&CBFill}:screen-value in {&Frame} = SELF:screen-value.

   /* Notify application of selection change. Since I can't apply
      an event to myself (the fill widget), apply to the fill (make
      sure it's enabled first. */
   {&CBFill}:sensitive in {&Frame} = yes.
   apply "U1" to {&CBFill} in {&Frame}.
end.


/*----- ON ANY-PRINTABLE (ASCII) of SELECT LIST -----*/
/*----- Do 1st letter navigation (only Motif doesn't do it natively -----*/
&IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN 
on ANY-PRINTABLE of {&CBList} in {&Frame} 
do:
   Define var lst_val as char NO-UNDO.

   run adecomm/_lstnav.p (INPUT {&CBList}:HANDLE in {&Frame},
      	       	     	 OUTPUT lst_val).

   if lst_val <> ? then
   do:
      /* Show the matching item in the fill-in */
      {&CBFill}:screen-value in {&Frame} = lst_val.

      /* Notify application of selection change. Since I can't apply
	 an event to myself send it to the fill widget.
      */
      {&CBFill}:sensitive in {&Frame} = yes.
      apply "U1" to {&CBFill} in {&Frame}.
   end.
end.
&ENDIF


/*-------------------------Initialization code--------------------------*/

/* Position the list box just below the fill-in. */
CB_x = {&CBFill}:x in {&Frame}.
CB_y = {&CBFill}:y in {&Frame}.
CB_height = {&CBFill}:height-pixels in {&Frame}.

{&CBList}:x in {&Frame} = CB_x.
{&CBList}:y in {&Frame} = CB_y + CB_height.

/* Initialize the list value */
if {&CBInit} <> "" then
   {&CBFill} = {&CBInit}.
else
   if {&CBList}:NUM-ITEMS > 0 then {&CBFill} = {&CBList}:entry(1) in {&Frame}.
{&CBList}:screen-value in {&Frame} = {&CBFill}.

/* Put fillin value in frame widget.  Don't use DISPLAY to avoid
   display of the frame - leave this up to caller to control.
*/
{&CBFill}:screen-value in {&Frame} = {&CBFill}.

{&CBFill}:sensitive in {&Frame} = yes.
{&CBList}:sensitive in {&Frame} = yes.








