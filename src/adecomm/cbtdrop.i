/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: cbtdrop.i (Combo Box Triggers Drop)

Description:
   This file contains only the trigger code controls a drop-down combo box.

   A drop-down combo box is one that contains a fill-in field, a button 
   and a selection list where the list will drop down (become visible)
   or pull up (become invisible) when the button or the fill-in are clicked on.

   This variety of drop combo box will not allow any value to be displayed 
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
   This file should be included any time after the FORM definition but
   before the frame is enabled.
   
   None of the combo box pieces need to be enabled by the caller
   (though the fill-in and button can be) The selection list variable
   should not be enabled by the caller.

   The fill-in, list and button variables need to be included 
   in the FORM but only the fill-in need be given a position.

Author: Laura Stern

Date Created: 03/06/92 

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

/*----- ON BACKSPACE, DELETE of FILL -----*/

on BACKSPACE, DEL, SHIFT-BACKSPACE, 
   CTRL-BACKSPACE, CTRL-DEL of {&CBFill} in {&Frame}
   /* Prevent any modification of fill-in value */
   return NO-APPLY.


/*----- ON ANY-PRINTABLE (ASCII) of FILL -----*/
on ANY-PRINTABLE of {&CBFill} in {&Frame}, {&CBList} in {&Frame} 
do:
   Define var lst_val as char NO-UNDO.

   run adecomm/_lstnav.p (INPUT {&CBList}:HANDLE in {&Frame},
      	       	     	 OUTPUT lst_val).

   if lst_val <> ? then
   do:
      /* Show the matching item in the fill-in */
      {&CBFill}:screen-value in {&Frame} = lst_val.

      /* Notify application of selection change. Since I can't apply
	 an event to myself send it to whatever the other widget is.
      */
      if SELF:type = "SELECTION-LIST" then
      	 apply "U1" to {&CBFill} in {&Frame}.
      else
      	 apply "U1" to {&CBList} in {&Frame}.
   end.

   /* Prevent the last character typed from appearing in the fill-in. 
      The only thing that should change the fill-in value is finding
      a match. */
   return NO-APPLY.
end.


/*----- MOUSE-DOWN on FILL -----*/
on "MOUSE-SELECT-DOWN" of {&CBFill} in {&Frame}
   run CB_Toggle_List (INPUT {&CBList}:HANDLE in {&Frame}).


/*----- MOUSE-UP on FILL -----*/
on "MOUSE-SELECT-UP" of {&CBFill} in {&Frame}
do:
   /* Prevent focus from moving to fill if the list box is down since
      we want the list box to have focus. */
   if {&CBList}:visible in {&Frame} = yes then
      return NO-APPLY.
   else
      return.
end.





