/***********************************************************************
* Copyright (C) 2000,2011 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/


/*----------------------------------------------------------------------------

File: _delete.p

Description:
   Process the Delete command to delete the currently selected object.

Input Parameters:
   p_Obj - The object type to delete.
 
Author: Laura Stern

Date Created: 02/24/92 
    Modified: 07/14/98 Added _Owner to _File finds D. McMann
              08/08/02 Eliminated any sequences whose name begins "$" - Peer Direct D. McMann
              10/01/02 DLM Changed check for SQL tables

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/capab.i}


Define INPUT PARAMETER p_Obj as integer.

Define var confirmed as logical init no.  /* this IS undoable */
Define var capab     as char    NO-UNDO.
Define var obj_str   as char    NO-UNDO.


/*========================Internal Procedures===============================*/

/*--------------------------------------------------------------------
   Remove the deleted item from the appropriate list in the browse
   window and if the deleted item is being shown in an edit window,
   destroy that window. 

   Input Parameters:
      p_List - The widget handle of the list to remove the item from.
      p_Val  - The name of the item deleted, i.e., the value to remove
      	       from the list.
      p_Obj  - The symbolic object number (e.g., {&OBJ_TBL})
----------------------------------------------------------------------*/
PROCEDURE CleanupDisplay:

Define INPUT   	     parameter p_List  as widget-handle.
Define INPUT   	     parameter p_Val   as char.
Define INPUT   	     parameter p_Obj   as integer.

Define var cnt as integer NO-UNDO.

   run adecomm/_delitem.p (INPUT p_List, INPUT p_Val, OUTPUT cnt).

   apply "value-changed" to p_List.      
   if cnt = 0 then
      /* If this was the last item in the list, the browse window and menu
      	 may need some adjusting. */
      run adedict/_brwadj.p (INPUT p_Obj, INPUT cnt).
end.


/*============================Mainline code================================*/

CURRENT-WINDOW = s_win_Browse.
s_Browse_Stat:screen-value in frame browse = "". /* clear status line */

CASE p_Obj:

   when {&OBJ_TBL} then
   do:
      find dictdb._File WHERE dictdb._File._File-name = "_File"
                          AND dictdb._File._Owner = "PUB" NO-LOCK.
      if NOT can-do(dictdb._File._Can-delete, USERID("DICTDB")) then
      do:
      	 message s_NoPrivMsg "delete table definitions."
      	    view-as ALERT-BOX ERROR buttons OK.
      	 return.
      end.
   
      find dictdb._File where RECID(dictdb._File) = s_TblRecId.
    
      /* Do some more checking to see if this file is deletable */
      if can-find (FIRST dictdb._View-ref
      	       	   where dictdb._View-ref._Ref-Table = dictdb._File._File-Name)
	  OR dictdb._File._Frozen then
      do:
	 message
	    "Frozen tables and tables participating in views cannot be deleted."
      	    view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.   
   
      if dictdb._File._Db-lang >= {&TBLTYP_SQL} then
      do:
	 message "This is a {&PRO_DISPLAY_NAME}/SQL table.  Use DROP TABLE."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.
   
      /* In Progress, we need an active primary index to delete a file. */
      if {adedict/ispro.i} then
      do:
    	 find dictdb._Index where RECID(dictdb._Index) = dictdb._File._Prime-Index NO-ERROR.
    	 if AVAILABLE dictdb._Index AND NOT dictdb._Index._Active then
    	 do:
    	    message "Tables without an active primary index cannot be deleted."
          	       	     view-as ALERT-BOX ERROR buttons OK.
    	    return.
    	 end.
      end.
      
      do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      	 /* Note: if there's an error, confirmed will remain "no". */
      	 confirmed = yes.  /* default to yes */
      	 message "Are you sure you want to delete table" s_CurrTbl "?"
      	       	  view-as ALERT-BOX QUESTION buttons YES-NO
      	       	  update confirmed.

      	 if confirmed then
      	 do:
	       /* delete tbl, it's indexes, fields and triggers */
      	    run adecomm/_setcurs.p ("WAIT").
	        {adecomm/deltable.i}

      	    run CleanupDisplay (INPUT s_lst_Tbls:HANDLE in frame browse,
      	       	     	        INPUT s_CurrTbl,
      	       	     	        INPUT {&OBJ_TBL}).
      	    obj_str = "Table".
      	    current-window = s_win_Browse.  /* cleanup may have changed it */
      	 end.
      end.
   end.

   when {&OBJ_SEQ} then
   do:
      /* Get gateway capabilities */
      run adedict/_capab.p (INPUT {&CAPAB_SEQ}, OUTPUT capab).
      if INDEX(capab, {&CAPAB_DELETE}) = 0 then
      do:
      	 message "You may not delete a sequence for this database type."
      	    view-as ALERT-BOX ERROR buttons OK.
      	 return.
      end.

      find dictdb._File WHERE dictdb._File._File-name = "_Sequence"
                          AND dictdb._File._Owner = "PUB" NO-LOCK.
      if NOT can-do(dictdb._File._Can-delete, USERID("DICTDB")) then
      do:
      	 message s_NoPrivMsg "delete sequence definitions."
      	    view-as ALERT-BOX ERROR buttons Ok.
      	 return.
      end.
   
      do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      	 /* Note: if there's an error, confirmed will remain "no". */
      	 confirmed = yes.  /* default to yes */
      	 message "Are you sure you want to delete sequence" s_CurrSeq "?"
      	       	  view-as ALERT-BOX QUESTION buttons YES-NO
      	       	  update confirmed.

      	 if confirmed then
      	 do:
      	    run adecomm/_setcurs.p ("WAIT").
      	    find dictdb._Sequence where dictdb._Sequence._Db-recid = s_DbRecId
                                    AND dictdb._Sequence._Seq-Name = s_CurrSeq.
      	    delete dictdb._Sequence.

      	    run CleanupDisplay (INPUT s_lst_Seqs:HANDLE in frame browse,
      	       	     	        INPUT s_CurrSeq,
      	       	     	        INPUT {&OBJ_SEQ}).
      	    obj_str = "Sequence".
      	    current-window = s_win_Browse.  /* cleanup may have changed it */
      	 end.
      end.
   end.

   when {&OBJ_FLD} then
   do:
      find dictdb._File WHERE dictdb._File._File-name = "_Field"
                          AND dictdb._File._Owner = "PUB" NO-LOCK.
      if NOT can-do(dictdb._File._Can-delete, USERID("DICTDB")) then
      do:
      	 message s_NoPrivMsg "delete field definitions."
      	    view-as ALERT-BOX ERROR buttons Ok.
      	 return.
      end.
   
      find dictdb._File where RECID(dictdb._File) = s_TblRecId.
      if dictdb._File._Db-lang >= {&TBLTYP_SQL} then
      do:
    	 message "This is a {&PRO_DISPLAY_NAME}/SQL table.  Use ALTER TABLE/DROP COLUMN."
          	       	  view-as ALERT-BOX ERROR buttons OK.
    	 return.
      end.
      if dictdb._File._Frozen then
      do:
      	 message "This field belongs to a frozen table." SKIP
      	       	 "It cannot be deleted"
      	       	  view-as ALERT-BOX ERROR buttons OK.
      	 return.
      end.
      
      find dictdb._Field of dictdb._File where dictdb._Field._Field-Name = s_CurrFld.
   
      /* Determine if this field participates in an index or view definition. */
      if can-find (FIRST dictdb._Index-field OF dictdb._Field) then
      do:
	      message "This field is used in an Index - cannot delete."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	      return.
      end.
      if can-find (FIRST dictdb._View-ref 
                   where dictdb._View-ref._Ref-Table = s_CurrTbl 
                     and dictdb._View-ref._Base-Col = dictdb._Field._Field-name) then
      do:
	      message "This field is used in a View - cannot delete."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	      return.
      end.
   
      do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      	 /* Note: if there's an error, confirmed will remain "no". */
      	 confirmed = yes.  /* default to yes */
      	 message "Are you sure you want to delete field" s_CurrFld "?"
      	       	  view-as ALERT-BOX QUESTION buttons YES-NO
      	       	  update confirmed.

      	 if confirmed then
      	 do:
	    /* Delete associated triggers, then the field record. */
      	    run adecomm/_setcurs.p ("WAIT").
    	 /* delete the associated constraints */
    	    
    	    for each dictdb._Constraint where dictdb._Constraint._Field-Recid = integer(recid(dictdb._Field)):
    	       for each dictdb._Constraint-Keys WHERE recid(dictdb._Constraint) = dictdb._Constraint-Keys._con-recid:
    	           delete dictdb._Constraint-Keys.
    	       end.
    	       delete dictdb._Constraint.
    	    end.    
    	    for each dictdb._Field-trig of dictdb._Field:
    	       delete dictdb._Field-trig.
    	    end.
    	    delete _Field.

      	    run CleanupDisplay (INPUT s_lst_Flds:HANDLE in frame browse,
      	       	     	        INPUT s_CurrFld,
      	       	     	        INPUT {&OBJ_FLD}).
      	    obj_str = "Field".
      	    current-window = s_win_Browse.  /* cleanup may have changed it */
	 end.
      end.
   end.

   when {&OBJ_IDX} then
   do:
      /* Get gateway capabilities */
      run adedict/_capab.p (INPUT {&CAPAB_IDX}, OUTPUT capab).
      if INDEX(capab, {&CAPAB_DELETE}) = 0 then
      do:
      	 message "You may not delete an index definition for this database type."
      	    view-as ALERT-BOX ERROR buttons OK.
      	 return.
      end.

      find dictdb._File WHERE dictdb._File._File-name = "_Index"
                          AND dictdb._File._Owner = "PUB" NO-LOCK.
      if NOT can-do(dictdb._File._Can-delete, USERID("DICTDB")) then
      do:
          message s_NoPrivMsg "delete index definitions."
      	      view-as ALERT-BOX ERROR buttons Ok.
      	  return.
      end.
   
      find dictdb._File where RECID(dictdb._File) = s_TblRecId.
      if dictdb._File._Db-lang >= {&TBLTYP_SQL} then
      do:
	     message "This is a {&PRO_DISPLAY_NAME}/SQL table.  Use the DROP INDEX statement."
      	     view-as ALERT-BOX ERROR buttons OK.
	     return.
      end.
      if dictdb._File._Frozen then
      do:
      	  message "This index belongs to a frozen table." SKIP
      	       	 "It cannot be deleted"
      	       	  view-as ALERT-BOX ERROR buttons OK.
      	  return.
      end.
   
      find dictdb._Index of dictdb._File where dictdb._Index._Index-Name = s_CurrIdx.
      if dictdb._File._Prime-Index = RECID(dictdb._Index) then
      do:
	      message "You cannot delete the primary index of a table."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	      return.
      end.
   
      do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      	 /* Note: if there's an error, confirmed will remain "no". */
      	 confirmed = yes.  /* default to yes */
      	 message "Are you sure you want to delete index" s_CurrIdx "?"
      	       	  view-as ALERT-BOX QUESTION buttons YES-NO
      	       	  update confirmed.

      	 if confirmed then
      	 do:
	         /* First delete the index fields, then the _Index record itself. */
      	     run adecomm/_setcurs.p ("WAIT").
             for each dictdb._Constraint where dictdb._Constraint._Index-Recid = integer(recid(dictdb._Index)):
                for each dictdb._Constraint-Keys WHERE recid(dictdb._Constraint) = dictdb._Constraint-Keys._con-recid:
    	           delete dictdb._Constraint-Keys.
    	        end.
    	        delete dictdb._Constraint.
    	     end.    
	         for each dictdb._Index-Field of dictdb._Index:
	             delete dictdb._Index-Field.
	         end.
	         delete dictdb._Index.

      	    run CleanupDisplay (INPUT s_lst_Idxs:HANDLE in frame browse,
      	       	     	        INPUT s_CurrIdx,
      	       	     	        INPUT {&OBJ_IDX}).
      	    obj_str = "Index".
      	    current-window = s_win_Browse.  /* cleanup may have changed it */
	     end.
      end.
   end.

   otherwise 
   do:
      /* This should never happen */
   end.

end case.

/* Make sure cursor is reset. Do it here so we know it will happen.
   Whether delete was successful or if STOP occurred or if they never
   confirmed - it won't matter.
*/
run adecomm/_setcurs.p ("").

if confirmed then
do:
   display obj_str + " deleted." @ s_Browse_Stat with frame browse.
   {adedict/setdirty.i &Dirty = "true"}.
end.







