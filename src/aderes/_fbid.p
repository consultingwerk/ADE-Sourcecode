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
 
