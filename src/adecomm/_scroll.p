/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _scroll.p

Description:
   Scroll the specified selection list so that the item with the given value 
   will be in view.

Input Parameters:
   p_List  - The widget handle of the selection list.
   p_Val   - The value of the item we want to scroll into view.

Author: Laura Stern

Date Created: 07/10/92 

----------------------------------------------------------------------------*/

/* Modifications

   02.26.93 jep
            Added bug 93-02-26-039 code workaround.  When bug is fixed,
            this code can be removed.
*/

Define INPUT PARAMETER p_List as widget-handle 	NO-UNDO.
Define INPUT PARAMETER p_Val  as char  	     	NO-UNDO.

Define var pos 	    as integer NO-UNDO.
Define var top_item as integer NO-UNDO.
Define var val      as char    NO-UNDO.
Define var err 	    as logical NO-UNDO.
Define var num_rows as integer NO-UNDO.


/* Determine which entry to position at the top so that p_Val is visible. */

pos      = p_List:Lookup(p_Val).
num_rows = p_List:inner-lines.

/* Bug 93-02-26-039 requires this workaround for TTY. */
IF ( num_rows = ? ) THEN num_rows = p_List:HEIGHT-CHARS.

if ( pos < num_rows ) then
   top_item = 1.
else
   top_item = pos - num_rows + 1.

/* Scroll that item to the top. */
val = p_List:entry(top_item).
err = p_List:scroll-to-item(val).



