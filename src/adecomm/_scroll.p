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



