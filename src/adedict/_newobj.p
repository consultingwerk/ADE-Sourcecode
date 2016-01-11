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




