/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _fbid.p - Save the current rowid from the form or browse view.
      	     This is called from generated code.

   Input Parameter:
      p_mode  - b = build, c = cleanup
      p_level - 1 = master level, 2 = detail level
      p_id    - the rowid or row #
*/

{ aderes/fbdefine.i }

DEFINE INPUT PARAMETER p_mode  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_level AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER p_id    AS CHARACTER NO-UNDO.

/* Current row may be ?.  If we put it in as "" to start, then we'll end
   up without a leading comma (i.e., we won't know to put the comma after
   it when the rowid comes in.)  So convert the ? to a "|" as a placeholder,
   since math with a ? returns a ?.  When we're done with this level, we'll 
   call this routine again to cleanup the "|" symbols. 
*/
IF p_id = ? THEN ASSIGN p_id = "|":u.

ASSIGN
  qbf-rowids[p_level] = IF p_mode = "b":u THEN
                          (qbf-rowids[p_level] 
      	       	           + (IF qbf-rowids[p_level] = "" THEN "" ELSE ",") 
      	       	           + p_id)
                        ELSE
                          REPLACE(qbf-rowids[p_level],"|":u,""). 

/* _fbid.p - end of file */
 
