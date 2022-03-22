/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: cbcomm.i (Combo Box Common)

Description: This contains triggers and internal procedures that
   are common between the drop.i code and the dropx.i code.

Author: Laura Stern

Date Created: 06/07/92 

---------------------------------------------------------------------------*/


/*======================Internal Procedures=============================*/

&IF DEFINED(CB_PROCS) = 0 &THEN	 /* So procs aren't defined twice */
&global-define CB_PROCS	   1

/*------------------------------------------------------------------
   Move the cursor up or down in the select list.

   Input Parameters:
      move_down    - If true, move it cursor down, otherwise move it up.
      p_list       - The selection list widget handle.
      p_fill       - The fill-in widget handle.
      notify_widg  - The application widget to notify if list value
      	       	     changed.

------------------------------------------------------------------*/
Procedure CB_Move_Cursor:

   define input parameter move_down   as logical       NO-UNDO.
   define input parameter p_list      as widget-handle NO-UNDO.
   define input parameter p_fill      as widget-handle NO-UNDO.
   define input parameter notify_widg as widget-handle NO-UNDO.

   define var val  as char.
   define var ix   as integer.
   define var orig as integer.

   assign
      val = p_list:screen-value
      ix = p_list:lookup(val) 
      orig = ix.
   
   if move_down then do:
      if ix < p_list:num-items then 
      	 assign
	    ix = ix + 1
	    p_list:screen-value = p_list:entry(ix).
   end.
   else do:
      if ix > 1 then 
      	 assign
	    ix = ix - 1
	    p_list:screen-value = p_list:entry(ix).
   end.

   if ix <> orig then do:
      p_fill:screen-value = p_list:screen-value.

      /* Notify application of change */
      apply "U1" to notify_widg.
   end.
end.


/*---------------------------------------------------------
   Toggle the down state of the select list.

   Input Parameters:
      p_list - The selection list widget handle.
---------------------------------------------------------*/
Procedure CB_Toggle_List:

   define input parameter p_list as widget-handle NO-UNDO.

   define var stat as logical NO-UNDO.

   /* Toggle "down" state of list box. */
   if p_list:visible = yes then
      p_list:visible = no.
   else do:
      assign   
      	 p_list:visible = yes
      	 stat = p_list:move-to-top().

      /* Give list box focus so user can use the keyboard for selection */
      apply "entry" to p_list.
   end.
end.

&ENDIF


/*==============================Triggers================================*/

/*----- CURSOR DOWN of FILL -----*/
on CURSOR-DOWN of {&CBFill} in {&Frame}
do:
   /* Move down through select list even though user 
      can't see it. Fill-in will reflect the value. */
   run CB_Move_Cursor (INPUT true, 
      	       	       INPUT {&CBList}:HANDLE in {&Frame},
      	       	       INPUT {&CBFill}:HANDLE in {&Frame},
      	       	       INPUT {&CBList}:HANDLE in {&Frame}).
   return NO-APPLY.
end.


/*----- CURSOR UP of FILL -----*/
on CURSOR-UP of {&CBFill} in {&Frame}
do:
   /* Move up through select list even though user 
      can't see it. Fill-in will reflect the value. */
   run CB_Move_Cursor (INPUT false, 
      	       	       INPUT {&CBList}:HANDLE in {&Frame},
      	       	       INPUT {&CBFill}:HANDLE in {&Frame},
      	       	       INPUT {&CBList}:HANDLE in {&Frame}).
   return NO-APPLY.
end.


/*----- CHOOSE of LIST ITEM -----*/
on value-changed of {&CBList} in {&Frame}
do:
   /* Reflect selection in fill-in. */
   if SELF:screen-value = ? then
      display "" @ {&CBFill} with {&Frame}.
   else
      display SELF:screen-value @ {&CBFill} with {&Frame}.

   /* Hide the list and make sure it no longer has focus. */
   {&CBList}:visible in {&Frame} = no.
   apply "entry" to {&CBFill} in {&Frame}.

   /* Notify the application of the change. */
   apply "U1" to {&CBFill} in {&Frame}.
end.


/*----- DEFAULT-ACTION (Return) on SELECTION-LIST-----*/
on default-action of {&CBList} in {&Frame}
do:
   /* Note: the selection hasn't changed.  Just cause the list to
      pull up.  Normally double click will also generate the
      default-action event but the actions taken on single click 
      (value-changed) will prevent the double click from coming in.
      Even if it did - this code is still appropriate.
   */
   {&CBList}:visible in {&Frame} = no.
end.


/*----- ALT-UP or ALT-DOWN -----*/
on ALT-CURSOR-UP, ALT-CURSOR-DOWN of {&CBFill} in {&Frame}
   /* This is the keyboard way of Toggling "down" state of list box. */
   Run CB_Toggle_List (INPUT {&CBList}:HANDLE in {&Frame}).


/*----- ALT-UP or ALT-DOWN -----*/
on ALT-CURSOR-UP, ALT-CURSOR-DOWN of {&CBLIST} in {&Frame}
do:
   /* This is the keyboard way of Toggling "down" state of list box. */
   Run CB_Toggle_List (INPUT {&CBList}:HANDLE in {&Frame}).

   /* Without this, focus will move to the next widget, and in this 
      case, we want it to stay within the combo box.
   */
   apply "entry" to {&CBFill} in {&Frame}.
end.


/*----- CHOOSE of BUTTON -----*/
on choose of {&CBBtn} in {&Frame}
do:
   /* If we just left the list it is already pulled up, so just reset
      the flag.  See ENTER of BUTTON trigger for more explanation */
   if CB_JustLeftList then
      CB_JustLeftList = false.
   else
      /* Toggle "down" state of list box. */
      Run CB_Toggle_List (INPUT {&CBList}:HANDLE in {&Frame}).
end.


/*----- ENTER of BUTTON -----*/
on entry of {&CBBtn} in {&Frame}
do:
   define var e_time as integer NO-UNDO.

   /* If the list box is down and we hit the button, we want to pull
      the list up.  Clicking the button will also cause a leave event
      on the list.  In general on leave of list, due to tabbing off it
      for example, we pull it up. However, if the leave from the list box
      was because we hit the button, then the list box has been pulled up
      already and we don't want to drop it down again.  The only way we
      can know that this has happened is to compare elapsed time. 
      If less than x milliseconds has elapsed since the time we left the
      list and the time of this button entry event (when we click on the 
      button we get entry event first and then selection) then we know that
      the list leave was caused by the button click!
   */
   if CB_ETime <> 0 then
      e_time = ETIME(false) - CB_ETime.

   if (CB_ETime <> 0) AND (e_time < 80) then
      CB_JustLeftList = true.
   else 
      CB_JustLeftList = false.
end.


/*----- LEAVE of LIST ----- */
on leave of {&CBList} in {&Frame}
do:
   /* Pull up the list, and mark the time that this happened. */
   assign
      {&CBList}:visible in {&Frame} = no
      CB_ETime = ETIME(false).
end.


/*-------------------------------------------------------------
   We can't tell the difference between clicking on an item
   with the mouse and using the cursor keys to move down to the
   next item (they both generate value-changed event).  However,
   we want the behavior to be different in each case.  Using the
   cursors should not cause the list to hide. So we have to
   handle the cursor keys ourselves.
-------------------------------------------------------------*/

/*----- CURSOR DOWN of LIST ----*/
on cursor-down of {&CBList} in {&Frame}
do:
   run CB_Move_Cursor (INPUT true, 
      	       	       INPUT {&CBList}:HANDLE in {&Frame},
      	       	       INPUT {&CBFill}:HANDLE in {&Frame},
      	       	       INPUT {&CBFill}:HANDLE in {&Frame}).
   return no-apply.
end.


/*----- CURSOR UP of LIST ----*/
on cursor-up of {&CBList} in {&Frame}
do:
   run CB_Move_Cursor (INPUT false, 
      	       	       INPUT {&CBList}:HANDLE in {&Frame},
      	       	       INPUT {&CBFill}:HANDLE in {&Frame},
      	       	       INPUT {&CBFill}:HANDLE in {&Frame}).
   return no-apply.
end.


