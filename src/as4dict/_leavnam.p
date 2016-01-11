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

{as4dict/dictvar.i shared}
/*{as4dict/uivar.i shared}
{adecomm/cbvar.i shared} */

Define INPUT  PARAMETER p_OrigName  as char           NO-UNDO.
Define INPUT  PARAMETER p_Win       as widget-handle  NO-UNDO.
Define INPUT  PARAMETER p_Obj_num   as integer        NO-UNDO.
DEFINE INPUT  PARAMETER p_obj       as integer        NO-UNDO.
Define OUTPUT PARAMETER p_Name      as char           NO-UNDO.
Define OUTPUT PARAMETER p_Okay      as logical        NO-UNDO.

Define variable aname               AS CHARACTER      NO-UNDO.
Define variable dname               AS CHARACTER      NO-UNDO.

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

/* Make sure there isn't already an object with this name.   */
CASE p_obj:
  WHEN {&OBJ_PARM} THEN DO:
    if can-find (first as4dict.p__Field where as4dict.p__Field._File-number = s_ProcForNo AND
                 as4dict.p__Field._Field-Name = p_name AND
                 as4dict.p__Field._Fld-number <> p_obj_num ) then  do:
          message "A parameter with this name already exists in this procedure."
                  view-as ALERT-BOX ERROR buttons OK.
    
      p_Okay = no.
    END.                  
  END.
  WHEN {&OBJ_PROC} THEN DO:
    if can-find (first as4dict.p__File where as4dict.p__File._File-Name = p_name
                 AND as4dict.p__File._File-number <> p_obj_num) then do:
      message "A procedure with this name already exists in this database."
               view-as ALERT-BOX ERROR
               buttons OK.
      p_okay = no.
    END.
  END.
  WHEN {&OBJ_TBL} THEN DO: 
    if can-find (first as4dict.p__File where as4dict.p__File._File-Name = p_name
                 AND as4dict.p__File._File-number <> p_obj_num) then do:
      message "A table with this name already exists in this database."
               view-as ALERT-BOX ERROR
               buttons OK.
      p_okay = no.
    END.
  END.
  WHEN {&OBJ_FLD} THEN DO:
  
    if can-find (first as4dict.p__Field where as4dict.p__Field._File-number = s_TblForNo AND
                 as4dict.p__Field._Field-Name = p_name AND
                 as4dict.p__Field._Fld-number <> p_obj_num ) then  do:
          message "A field with this name already exists in this table."
                  view-as ALERT-BOX ERROR buttons OK.
    
      p_Okay = no.
    END.
  END.
  WHEN {&OBJ_SEQ} THEN DO:
    if can-find (first as4dict.p__seq where as4dict.p__Seq._Seq-Name = p_name) then  do:
          message "A sequence with this name already exists in this database."
                  view-as ALERT-BOX ERROR buttons OK.
    
      p_Okay = no.
    END.                                    
  END.
  WHEN {&OBJ_IDX} THEN DO:
    IF LENGTH(p_name) > 0 THEN DO:
      if can-find (first as4dict.p__Index where as4dict.p__Index._File-number = s_TblForNo AND
                  as4dict.p__Index._Index-Name = p_name) then do:
        message "An index with this name already exists for this table."
             view-as ALERT-BOX ERROR  buttons OK.
      
        p_Okay = no.
      END.
    END.
  END.
END.

if p_Okay then
   SELF:screen-value = p_Name.  /* Reset the trimmed value */






