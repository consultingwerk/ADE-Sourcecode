/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _blnknam.p

Description:
   Determine if the name of an object is blank or ?. 

Input Parameters:
   p_Widget - The handle to the widget holding the name to check.
   p_Obj    - String denoting the object type that this name belongs to
      	      (e.g., "table").
   
Output Parameters:
   p_Blank  - Set to true if name is blank or ?.
 
Author: Laura Stern

Date Created: 07/10/92 

----------------------------------------------------------------------------*/

Define INPUT  PARAMETER p_Widget as widget-handle NO-UNDO.
Define INPUT  PARAMETER p_Obj    as char       	  NO-UNDO.
Define OUTPUT PARAMETER p_Blank  as logical  	  NO-UNDO.

Define var name as char NO-UNDO.

p_Obj = p_Obj + ".".
name = p_Widget:screen-value.

if name = "" OR name = "?" then
do:
   message "Please enter a name for this" p_Obj
   	    view-as ALERT-BOX ERROR buttons OK.
   p_Blank = true.

   /* Set focus there so the user can enter a name */
   apply "entry" to p_Widget. 
end.
else
   p_Blank = false.
