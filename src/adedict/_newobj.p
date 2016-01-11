/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _newobj.p

Description:
   Add the name of the object just created to the appropriate list box,
   select it and cause it to scroll into view.

Input Parameters
   p_List   - The list box widget to add the item to.
   p_Name   - The name of the object (i.e., the string) to add to the list.
   p_InsPos - The name of the object who's position the new entry will take
      	      (i.e., the name that we will insert the new one in front of).
      	      If this is blank, the new name will be added at the end.
   p_Cached - Flag indicating if select list is currently cached.
   p_Obj    - The symbolic object number (e.g., {&OBJ_TBL})

Author: Laura Stern

Date Created: 03/02/92 

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}


Define INPUT PARAMETER p_List 	 as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Name 	 as char  	  NO-UNDO.
Define INPUT PARAMETER p_InsPos  as char     	  NO-UNDO.
Define INPUT PARAMETER p_Cached  as logical  	  NO-UNDO.
Define INPUT PARAMETER p_Obj     as integer  	  NO-UNDO.


if p_Cached then
do:
   if p_InsPos = "" then
      s_Res = p_List:ADD-LAST(p_Name).
   else
      s_Res = p_List:INSERT(p_Name, p_InsPos).

   p_List:screen-value = p_Name.
   run adecomm/_scroll.p (INPUT p_List, INPUT p_Name).

   apply "value-changed" to p_List.

   /* If this is the only item in the list, (i.e., the list was previously
      empty) the browse window and menu may need some adjusting. */
   if p_List:NUM-ITEMS = 1 then
      run adedict/_brwadj.p (INPUT p_Obj, INPUT 1).
end.




