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

File: _delete.p

Description:
   Process the Delete command to delete the currently selected object.

Input Parameters:
   p_Obj - The object type to delete.
 
Author: Laura Stern

Date Created: 02/24/92 

Modified for PROGRESS/400 Dictionary:  11/15/94  nhorn   
         03/25/96 D. McMann Changed QUESTION to WARNING in messages
         05/24/96 D. McMann Added dltobj if new index not commited and
                            removed question if index was old primary
         06/26/97 D. McMann Added support for word indexes                   
         08/07/97 D. McMann Changed messages associated with deleting word index.
         08/28/97 D. McMann Added zeroing out of _Fil-Res1[7] if <0 97-08-28-011
         03/24/98 D. McMann Added assignment to _Fil-misc1[1] when index is deleted
                            98-01-07-003   
         05/12/99 D. McMann Added stored procedure support      
----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{as4dict/capab.i}


Define INPUT PARAMETER p_Obj as integer.

Define var confirmed as logical init no.  /* this IS undoable */
Define var capab     as char    NO-UNDO.
Define var obj_str   as char    NO-UNDO.
Define var endmsg as char    NO-UNDO.       
Define var msg as character NO-UNDO.
Define var dltphy as logical initial no. /* this is undoable */
      
Define buffer as4_Field for as4dict.p__Field.
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
      run as4dict/_brwadj.p (INPUT p_Obj, INPUT cnt).
end.


/*============================Mainline code================================*/

CURRENT-WINDOW = s_win_Browse.
s_Browse_Stat:screen-value in frame browse = "". /* clear status line */

CASE p_Obj:
   when {&OBJ_TBL} then
   do:
      find as4dict.p__File where as4dict.p__File._For-Number = s_TblForNo.
    
      /* Do some more checking to see if this file is deletable */
      if can-find (FIRST as4dict.p__vref
      	       	   where as4dict.p__vref._Ref-Table = as4dict.p__File._File-Name)
	           OR as4dict.p__File._Frozen = "Y" then
      do:
        message
	    "Frozen tables and tables participating in views cannot be deleted."
      	    view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.   
   
      if as4dict.p__File._Db-lang = {&TBLTYP_SQL} then
      do:
	 message "This is a PROGRESS/SQL table.  Use DROP TABLE."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.
      
      do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:      
        
         /* Note: if there's an error, confirmed will remain "no". */
         confirmed = yes.  /* default to yes */  
         assign endmsg = s_CurrTbl + "?".
         message "Are you sure you want to delete table" endmsg
      	       	  view-as ALERT-BOX WARNING buttons YES-NO
      	       	  update confirmed.

           if confirmed then do:            
                IF substring(as4dict.p__File._Fil-misc2[4],8,1) <> "Y" THEN DO:
                    {as4dict/setdirty.i &Dirty = "true"}.                          
                    dltphy = yes.
                    message "Should the DB2/400 physical file be deleted?"  
     	       	            view-as ALERT-BOX WARNING buttons YES-NO
      	       	            update dltphy.       
      	       	  
                    IF dltphy then do:
                        dba_cmd = "CHKF".
                        RUN as4dict/_dbaocmd.p 
	               (INPUT "PF", 
	                 INPUT as4dict.p__File._AS4-File,
      	                 INPUT as4dict.p__File._AS4-Library,
	                 INPUT 0,
	                 INPUT 0).     

                        IF dba_return = 1 THEN DO:
                            dba_cmd = "RESERVE".
                            RUN as4dict/_dbaocmd.p 
	                   (INPUT "PF", 
	                   INPUT as4dict.p__File._AS4-File,
      	                   INPUT as4dict.p__File._AS4-Library,
	                   INPUT 0,
	                   INPUT 0).                       
	                   
                            dba_cmd = "DLTOBJ".
                            RUN as4dict/_dbaocmd.p 
	                   (INPUT "PF", 
	                   INPUT as4dict.p__File._AS4-File,
      	                   INPUT as4dict.p__File._AS4-Library,
	                   INPUT as4dict.p__file._File-number,
	                   INPUT 0).     
                        END.            
                        ELSE IF dba_return = 11 THEN DO:              
                            dltphy = yes.
                            MESSAGE "The DBA command returned a wrong file format message"
                                             "which means the server schema is not in sync with the"
                                             "physical file."  SKIP
                                             "Do you still want to delete the DB2/400 physical file?"  
     	       	                         view-as ALERT-BOX WARNING buttons YES-NO
      	       	                       update dltphy.   
      	                    IF dltphy THEN DO:
      	                        dba_cmd = "RESERVE".
                                RUN as4dict/_dbaocmd.p 
	                          (INPUT "PF", 
	                           INPUT as4dict.p__File._AS4-File,
      	                           INPUT as4dict.p__File._AS4-Library,
	                           INPUT 0,
	                           INPUT 0).                       
	                   
                                dba_cmd = "DLTOBJ".
                                RUN as4dict/_dbaocmd.p 
	                          (INPUT "PF", 
	                           INPUT as4dict.p__File._AS4-File,
      	                           INPUT as4dict.p__File._AS4-Library,
	                           INPUT as4dict.p__file._File-number,
	                           INPUT 0).     
                           END.
                        END.            	      
                    END.
                 END.   	     	    	      	     
	        /* delete tbl, it's indexes, fields and triggers */
      	        run adecomm/_setcurs.p ("WAIT").  
  	/* If an index has been created but not committed and now they are deleting
      	   the file, the placeholder must be deleted here since there is no database
      	   relations to handle */
      	   FOR EACH as4dict.p__Index WHERE as4dict.p__Index._File-number = as4dict.p__File._File-Number:
      	     IF as4dict.p__Index._I-Misc1[1] = 0 AND as4dict.p__Index._Wordidx = 0 THEN DO:     
      	         dba_cmd = "CHKF".
      	         RUN as4dict/_dbaocmd.p 
	               (INPUT "PF", 
	                INPUT as4dict.p__Index._AS4-File,
      	                INPUT as4dict.p__Index._AS4-Library,
	                INPUT 0,
	                INPUT 0).     
                    
                 IF dba_return = 1 THEN DO:
                    dba_cmd = "RESERVE".
                    RUN as4dict/_dbaocmd.p 
	                (INPUT "PF", 
	                 INPUT as4dict.p__Index._AS4-File,
      	                 INPUT as4dict.p__Index._AS4-Library,
	                 INPUT 0,
	                 INPUT 0).                       
	                  
                    dba_cmd = "DLTOBJ".
                    RUN as4dict/_dbaocmd.p 
	                 (INPUT "PF", 
	                  INPUT as4dict.p__Index._AS4-File,
      	                  INPUT as4dict.p__Index._AS4-Library,
	                  INPUT as4dict.p__Index._File-number,
	                  INPUT as4dict.p__Index._Idx-num).     
                END.  
            END.         
        END. 
	{as4dict/deltable.i}

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
        do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      	 /* Note: if there's an error, confirmed will remain "no". */      
      	 assign endmsg = s_CurrSeq + "?".
      	 confirmed = yes.  /* default to yes */
      	 message "Are you sure you want to delete sequence"  endmsg
      	       	  view-as ALERT-BOX WARNING buttons YES-NO
      	       	  update confirmed.

      	 if confirmed then
      	 do:
      	    run adecomm/_setcurs.p ("WAIT").
      	    find as4dict.p__Seq where as4dict.p__Seq._Seq-Name = s_CurrSeq.
      	    delete as4dict.p__Seq.

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

      find as4dict.p__File where as4dict.p__File._For-Number = s_TblForNo.        
      IF  SUBSTRING(as4dict.p__File._Fil-misc2[4],8,1) = "Y"  THEN DO:    
        if as4dict.p__file._For-flag = 1 then msg = "Limited logical virtural table can't be modified".
        else if as4dict.p__file._For-flag = 2 then msg = "Multi record virtural table can't be modified".
        else if as4dict.p__file._For-flag = 3 then msg = "Joined logical virtural table can't be modified".
        else if as4dict.p__file._For-flag = 4 then msg = "Program described virtural table can't be modified".
        else if as4dict.p__file._For-flag = 5 then msg = "Multi record program described virtual can't be modified".
        else msg = "Virtural file/table can't be modified".
  
        message msg  SKIP view-as ALERT-BOX ERROR buttons OK.
        return.
    end.            
      
      if as4dict.p__File._Db-lang = {&TBLTYP_SQL} then
      do:
	 message "This is a PROGRESS/SQL table.  Use ALTER TABLE/DROP COLUMN."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.
      if as4dict.p__File._Frozen = "Y" then
      do:
      	 message "This field belongs to a frozen table." SKIP
      	       	 "It cannot be deleted"
      	       	  view-as ALERT-BOX ERROR buttons OK.
      	 return.
      end.
      
      find as4dict.p__Field where as4dict.p__field._file-number = s_TblForNo 
         AND as4dict.p__Field._Field-Name = s_CurrFld.
   
      /* Determine if this field participates in an index or view definition. */
      if can-find (FIRST as4dict.p__Idxfd where as4dict.p__Idxfd._File-number = as4dict.p__Field._File-number 
                                 and as4dict.p__Idxfd._Fld-number = as4dict.p__Field._Fld-number) then
      do:
	 message "This field is used in an Index - cannot delete."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.                                         

      if can-find (FIRST as4dict.p__vref where
		     as4dict.p__vref._Ref-Table = s_CurrTbl AND
		     as4dict.p__vref._Base-Col = as4dict.p__Field._Field-name) then
      do:
	 message "This field is used in a View - cannot delete."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.
   
      do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      	 /* Note: if there's an error, confirmed will remain "no". */
      	 confirmed = yes.  /* default to yes */          
      	 endmsg = s_CurrFld + "?".
      	 message "Are you sure you want to delete field"  endmsg
      	       	  view-as ALERT-BOX WARNING buttons YES-NO
      	       	  update confirmed.

      	 if confirmed then
      	 do:
	    /* Delete associated triggers, then the field record. */
	          	    run adecomm/_setcurs.p ("WAIT").


	    for each as4dict.p__trgfd where  as4dict.p__trgfd._File-number = as4dict.p__field._File-number
	                                                             and as4dict.p__trgfd._Fld-number = as4dict.p__Field._Fld-number:
	       delete as4dict.p__trgfd.
	    end.            
	    if as4dict.p__Field._Extent > 0 then do:                        
	       for each as4_field where as4_field._File-number = as4dict.p__Field._File-number
	                                                 and as4_Field._Fld-misc1[7] = as4dict.p__Field._Order:
	             delete as4_field.
	        end.    
	    end.       
	    if as4dict.p__Field._Fld-stdtype = 41 then do:
	       find as4_field where as4_field._File-number = as4dict.p__Field._File-number
	                                        and as4_Field._Fld-stoff = as4dict.p__Field._For-xpos no-error.
	       If available as4_field then delete as4_field.
	    end.                                                                 
	    delete as4dict.p__Field.
                      assign as4dict.p__File._numfld = (as4dict.p__File._numfld - 1).
      	    run CleanupDisplay (INPUT s_lst_Flds:HANDLE in frame browse,
      	       	     	        INPUT s_CurrFld,
      	       	     	        INPUT {&OBJ_FLD}).
      	    obj_str = "Field".
      	    current-window = s_win_Browse.  /* cleanup may have changed it */
	 end.
      end.
   end.
  
   when {&OBJ_IDX} then do:
      find as4dict.p__File where as4dict.p__File._File-number = s_TblForNo.
             
      IF  SUBSTRING(as4dict.p__File._Fil-misc2[4],8,1) = "Y"  THEN DO:    
         if as4dict.p__file._For-flag = 1 then msg = "Limited logical virtural table can't be modified".
        else if as4dict.p__file._For-flag = 2 then msg = "Multi record virtural table can't be modified".
        else if as4dict.p__file._For-flag = 3 then msg = "Joined logical virtural table can't be modified".
        else if as4dict.p__file._For-flag = 4 then msg = "Program described virtural table can't be modified".
        else if as4dict.p__file._For-flag = 5 then msg = "Multi record program described virtual can't be modified".
        else msg = "Virtural file/table can't be modified".
  
        message msg  SKIP view-as ALERT-BOX ERROR buttons OK.
        return.
    end.            
      
      if as4dict.p__File._Db-lang = {&TBLTYP_SQL} then
      do:
	 message "This is a PROGRESS/SQL table.  Use the DROP INDEX statement."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.
      if as4dict.p__File._Frozen  = "Y" then
      do:
      	 message "This index belongs to a frozen table." SKIP
      	       	 "It cannot be deleted"
      	       	  view-as ALERT-BOX ERROR buttons OK.
      	 return.
      end.
   
      find as4dict.p__Index where as4dict.p__Index._file-number = as4dict.p__file._File-Number
           AND as4dict.p__Index._Index-Name = s_CurrIdx.
  
      if as4dict.p__File._Prime-Index = as4dict.p__Index._idx-num then
      do:
	 message "You cannot delete the primary index of a file."
      	       	  view-as ALERT-BOX ERROR buttons OK.
	 return.
      end.


      do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      	 /* Note: if there's an error, confirmed will remain "no". */          
            endmsg = s_Curridx + "?". 	 
            confirmed = yes.  /* default to yes */
         
         /*If this file has already been processed prior the physical file key number
           will be negative so just zero it out.  97-08-28-011 */   
          IF as4dict.p__File._Fil-Res1[7] < 0 THEN
                 ASSIGN as4dict.p__File._Fil-Res1[7] = 0.
            
            If as4dict.p__file._Fil-misc1[7] = as4dict.p__Index._Idx-num then do:
	
	message "This index is the physical file key.  If you delete it,"
                "the physical file will no longer be keyed."  SKIP (1) 
                "Do you still want to delete this index?" SKIP
              	 view-as ALERT-BOX WARNING buttons YES-NO
		update confirmed. 

	IF confirmed then 
   	    ASSIGN as4dict.p__File._Fil-misc1[7] = -1.
          END.
          ELSE 		
            message "Are you sure you want to delete index" endmsg
      	       	  view-as ALERT-BOX WARNING buttons YES-NO
      	       	  update confirmed.

            if confirmed then do:                 
            
              assign as4dict.p__file._numkey = (as4dict.p__file._numkey - 1)
                     as4dict.p__file._fil-Res1[1] = as4dict.p__file._Fil-Res1[1] + 1
                     as4dict.p__file._Fil-misc1[1] = as4dict.p__file._Fil-misc1[1] + 1.
                     
              IF as4dict.p__Index._Idx-num < as4dict.p__File._Fil-Res1[3] OR 
                as4dict.p__file._Fil-Res1[3] = 0 then
                  assign as4dict.p__file._Fil-Res1[3] =  as4dict.p__Index._Idx-num.                     
            
                    
              if substring(as4dict.p__Index._I-misc2[4], 9,1) <> "Y" THEN DO: 
                /* If _fil-res1[7] is equal to the index number then this index
                   has not been create yet and had been the primary to begin with.
                   Delete the placeholder here */
                IF as4dict.p__file._fil-res1[7] = as4dict.p__Index._Idx-num THEN DO:
                    RUN as4dict/_dbaocmd.p 
	                          (INPUT "PF", 
	                           INPUT as4dict.p__Index._AS4-File,
      	                           INPUT as4dict.p__Index._AS4-Library,
	                           INPUT 0,
	                           INPUT 0).     
                        
                    IF dba_return = 1 THEN DO:
                       dba_cmd = "RESERVE".
                       RUN as4dict/_dbaocmd.p 
	                    (INPUT "PF", 
	                     INPUT as4dict.p__Index._AS4-File,
      	                     INPUT as4dict.p__Index._AS4-Library,
	                     INPUT 0,
	                     INPUT 0).                       
	                   
                       dba_cmd = "DLTOBJ".
                       RUN as4dict/_dbaocmd.p 
	                    (INPUT "PF", 
	                     INPUT as4dict.p__Index._AS4-File,
      	                     INPUT as4dict.p__Index._AS4-Library,
	                     INPUT as4dict.p__Index._File-number,
	                     INPUT as4dict.p__Index._Idx-num).     
                    END.  
                  END.         
                  else do:
                    dltphy= yes.
                    IF as4dict.p__Index._Wordidx = 0 THEN   
                       message "Should the DB2/400 logical file be deleted?"  
     	       	           view-as ALERT-BOX WARNING buttons YES-NO
      	       	           update dltphy.       
      	       	ELSE
      	       	   message "Should the DB2/400 *USRSPC be deleted?"  
     	       	           view-as ALERT-BOX WARNING buttons YES-NO
      	       	           update dltphy.        
           	  
                    IF dltphy then do:
                      IF as4dict.p__Index._Wordidx = 0 THEN DO:
                        dba_cmd = "CHKF".
                        RUN as4dict/_dbaocmd.p 
	                          (INPUT "LF", 
	                           INPUT as4dict.p__Index._AS4-File,
      	                           INPUT as4dict.p__Index._AS4-Library,
	                           INPUT 0,
	                           INPUT 0).     
                        
                         IF dba_return = 1 THEN DO:
                            dba_cmd = "RESERVE".
                            RUN as4dict/_dbaocmd.p 
	                       (INPUT "LF", 
	                       INPUT as4dict.p__Index._AS4-File,
      	                       INPUT as4dict.p__Index._AS4-Library,
	                       INPUT 0,
	                       INPUT 0).                       
	                   
                             dba_cmd = "DLTOBJ".
                             RUN as4dict/_dbaocmd.p 
	                      (INPUT "LF", 
	                        INPUT as4dict.p__Index._AS4-File,
      	                        INPUT as4dict.p__Index._AS4-Library,
	                        INPUT as4dict.p__Index._File-number,
	                        INPUT as4dict.p__Index._Idx-num).     
                          END.  
                        END.  
                        ELSE DO:
                          dba_cmd = "DLTOBJ".
                             RUN as4dict/_dbaocmd.p 
	                      (INPUT "*USRIDX", 
	                        INPUT as4dict.p__Index._AS4-File,
      	                        INPUT as4dict.p__Index._AS4-Library,
	                        INPUT as4dict.p__Index._File-number,
	                        INPUT as4dict.p__Index._Idx-num).     
                         END.    
                       END.  
                      END.  
                    END.   	    	      	           	          
	    /* First delete the index fields, then the p__Index record itself. */
      	    run adecomm/_setcurs.p ("WAIT").
	    for each as4dict.p__IdxFd where   as4dict.p__Idxfd._File-number = as4dict.p__File._File-number
	                                                              and as4dict.p__IdxFd._Idx-num = as4dict.p__index._idx-num:
	       delete as4dict.p__IdxFd.
	    end.
	    delete as4dict.p__Index.

      	    run CleanupDisplay (INPUT s_lst_Idxs:HANDLE in frame browse,
      	       	     	        INPUT s_CurrIdx,
      	       	     	        INPUT {&OBJ_IDX}).
      	    obj_str = "Index".
      	    current-window = s_win_Browse.  /* cleanup may have changed it */
        end.  
      end.
   end.
   when {&OBJ_PROC} then do:
     find as4dict.p__File where as4dict.p__File._For-Number = s_ProcForNo.    
      
     do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:      
        
       /* Note: if there's an error, confirmed will remain "no". */
       ASSIGN confirmed = yes  /* default to yes */  
              endmsg = s_CurrProc + "?".
       message "Are you sure you want to delete procedure" endmsg
      	  view-as ALERT-BOX WARNING buttons YES-NO update confirmed.

       if confirmed then do:            
         run adecomm/_setcurs.p ("WAIT").  
         
	  /* Delete All parameters */
         FOR EACH as4dict.p__Field WHERE as4dict.p__field._file-number = as4dict.p__file._File-Number:     
           DELETE as4dict.p__Field.
         END.                   

         /* Delete the procedure record itself */
         DELETE as4dict.p__File.

         run CleanupDisplay (INPUT s_lst_Proc:HANDLE in frame browse,
                           INPUT s_CurrProc,
                           INPUT {&OBJ_PROC}).
      	 obj_str = "Procedure".
      	 current-window = s_win_Browse.  /* cleanup may have changed it */
      end.
    end.
  end.
  when {&OBJ_PARM} then do:
    find as4dict.p__File where as4dict.p__File._For-Number = s_ProcForNo.                  
    find as4dict.p__Field where as4dict.p__field._file-number = s_ProcForNo 
                            AND as4dict.p__Field._Field-Name = s_CurrParm.      
   
      do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      	 /* Note: if there's an error, confirmed will remain "no". */
      	 confirmed = yes.  /* default to yes */          
      	 endmsg = s_CurrParm + "?".
      	 message "Are you sure you want to delete parameter " endmsg
      	       	  view-as ALERT-BOX WARNING buttons YES-NO
      	       	  update confirmed.

      	 if confirmed then
      	 do:	                                                            
	   delete as4dict.p__Field.
          assign as4dict.p__File._numfld = (as4dict.p__File._numfld - 1).
      	   run CleanupDisplay (INPUT s_lst_Parm:HANDLE in frame browse,
      	       	     	        INPUT s_CurrParm,
      	       	     	        INPUT {&OBJ_PARM}).
      	    obj_str = "Parameter".
      	    current-window = s_win_Browse.  /* cleanup may have changed it */
	 end.
      end.
   end.
   otherwise do:
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
   {as4dict/setdirty.i &Dirty = "true"}.
end.




