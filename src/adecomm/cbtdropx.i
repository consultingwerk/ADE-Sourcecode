/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: cbtdropx.i (Combo Box Triggers Dropx)

Description:
   This file contains only the trigger code controls an editable drop-down 
   combo box.

   A drop-down combo box is one that contains a fill-in field, a button 
   and a selection list where the list will drop down (become visible)
   or pull up (become invisible) when the button or the fill-in are clicked on.

   This variety of drop combo box will allow a value to be displayed 
   in the fill-in that is not in the drop down list.

Arguments:
   &Frame   - The name of the frame that the combo box appears in, 
      	      e.g., "frame foo".
   &CBFill  - The variable that is the fill-in field part of the
      	      combo box.
   &CBList  - The variable that is the selection list part of the
      	      combo box.
   &CBBtn   - The button that is the button component of the combo box.
      	      This should have been defined with IMAGE-UP FILE "adeicon/cbbtn".
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
   
   None of the combo box pieces need to be SENSITIVE by the caller
   (though the fill-in and button can be) The selection list variable
   should not be SENSITIVE by the caller.

   The fill-in, list and button variables need to be included 
   in the FORM but only the fill-in need be given a position.

Author: Laura Stern

Date Created: 07/29/92 

----------------------------------------------------------------------------*/

/* triggers and internal procedures common between this and
   cbtdropx.i (most of the code is in here).
*/
{adecomm/cbcomm.i
   &Frame  = "{&Frame}"
   &CBFill = "{&CBFill}"
   &CBList = "{&CBList}"
   &CBBtn  = "{&CBBtn}"
}


/*==============================Triggers================================*/

/*----- LEAVE of FILL -----*/
on leave of {&CBFill} in {&Frame}
do:
   if SELF:screen-value <> "" then 
   do:
      /* If the fill-in value matches an item in the list, set 
      	 selection to that list item and make sure it will be
      	 in view then next time the list is dropped down. */
      if {&CBList}:lookup(SELF:screen-value) in {&Frame} <> 0 then
      do:
      	 {&CBList}:screen-value in {&Frame} = SELF:screen-value.
      	 run adecomm/_scroll.p (INPUT {&CBList}:HANDLE in {&Frame},
			       INPUT SELF:screen-value).
      end.
   end.

   /* Notify the application of the change (even when it's blank). */
   apply "U1" to {&CBList} in {&Frame}.
end.

