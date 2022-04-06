/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _leavnam.p

Description:
   The name field of a create dialog or property window has been "left".
   Check the name to see if it's allright.

   Note: This is a separate .p instead of an internal procedure in edittrig.i
   in order to make edittrig.i smaller.  I was hitting the size limit!.

Input Parameters:
   p_OrigName - If editing, this was the original name before we sensitive it
      	        for edit.  If adding, this is ignored.
   p_Win      - If editing the window to parent any alert boxes to.  If
      	        adding this is ignored.

Output Parameters:
   p_Name     - Set to the new name value.
   p_Okay     - Set to:
      	       	  yes if name is okay, and validation on it should continue.
      	       	  no  if name is invalid and caller should return NO-APPLY
      	       	  ?   if name if blank or unchanged and caller should return
      	       	      without further processing.
 
Author: Laura Stern

Date Created: 07/14/92 

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}

Define INPUT  PARAMETER p_OrigName  as char    	      NO-UNDO.
Define INPUT  PARAMETER p_Win  	    as widget-handle  NO-UNDO.
Define OUTPUT PARAMETER p_Name 	    as char 	      NO-UNDO.
Define OUTPUT PARAMETER p_Okay 	    as logical 	      NO-UNDO.


p_Name = TRIM (SELF:screen-value). 
p_Okay = ?.

if NOT s_Adding then
do:
   /* If editing and the name hasn't been changed from what it started 
      as, do nothing. */ 
   if LC(p_OrigName) = LC(p_Name) then
      return.

   /* To parent any alert boxes properly.  Since add is modal, we know 
      it's parent is still correct. */
   current-window = p_Win.
end.

/* Make sure the name is a valid identifier for Progress.  Allow it
   to be blank or unknown. */
run adecomm/_valname.p (INPUT p_Name, INPUT true, OUTPUT p_Okay).

if p_Okay then
   SELF:screen-value = p_Name.  /* Reset the trimmed value */





