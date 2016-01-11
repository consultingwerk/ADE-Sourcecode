/***********************************************************************
* Copyright (C) 2000-2010,2013 by Progress Software Corporation. All   *
* rights reserved.  Prior versions of this work may contain portions   *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*----------------------------------------------------------------------------

File: _savetbl.p

Description:
   Save any changes the user made in the table property window. 

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Laura Stern

Date Created: 07/14/92
    Modified: D. McMann 06/29/98 Added _Owner to _File find

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adedict/TBL/tblvar.i shared}

Define var oldname  as char CASE-SENSITIVE NO-UNDO.
Define var newname  as char CASE-SENSITIVE NO-UNDO.
Define var junk     as logical       	   NO-UNDO.
Define var no_name  as logical 	       	   NO-UNDO.
Define var cnt      as integer             NO-UNDO.
Define var oldhid   as logical             NO-UNDO.
Define var nxtname  as char                NO-UNDO.
Define var ins_name as char                NO-UNDO.
Define var mtBad    as log                 NO-UNDO.

current-window = s_win_Tbl.

/* Check if name is blank and return if it is */
run adedict/_blnknam.p
   (INPUT b_File._File-Name:HANDLE in frame tblprops,
    INPUT "table", OUTPUT no_name).
if no_name then return "error".
 
assign
   oldname = b_File._File-Name
   newname = input frame tblprops b_File._File-Name
   oldhid  = b_File._Hidden.

do with frame tblprops:
    if input b_File._File-Attributes[1] and not b_File._File-Attributes[1] then
    do:
        run adedict/TBL/_okmttbl.p(input input b_File._File-Attributes[2], output mtBad). 
        if mtBad then
        do:
            return "error".
        end.    
    end.     
end.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   run adecomm/_setcurs.p ("WAIT").
   
   /* Any sub-dialog changes (e.g., triggers)  have already been saved.  
      We just need to move main property values into buffer. */
   assign
      b_File._File-Name = newname
      input frame tblprops b_File._File-Attributes[1] when 
             input frame tblprops b_File._File-Attributes[1]
      input frame tblprops b_File._File-Attributes[2] when 
             input frame tblprops b_File._File-Attributes[2]
      input frame tblprops b_File._File-Attributes[3] when 
             input frame tblprops b_File._File-Attributes[3]
      input frame tblprops b_File._Dump-Name
      input frame tblprops b_File._Hidden
      input frame tblprops b_File._For-Size
      input frame tblprops b_File._File-label
      input frame tblprops b_File._Desc
      input frame tblprops b_File._Fil-misc2[6].

   if b_File._For-Name:sensitive in frame tblprops then
      b_File._For-Name = input frame tblprops b_File._For-Name.
   if s_Tbl_Type:sensitive in frame tblprops then
      b_File._For-type = input frame tblprops s_Tbl_Type.
  
   if NOT oldhid AND b_File._Hidden AND NOT s_Show_Hidden_Tbls then
   do:
      /* If hidden was changed to yes, and Show_Hidden flag is off, 
      	 remove the table from the browse window table list. */
      run adecomm/_delitem.p (INPUT s_lst_Tbls:HANDLE in frame browse, 
      	       	     	     INPUT oldname, OUTPUT cnt).
      apply "value-changed" to s_lst_Tbls in frame browse.
      if cnt = 0 then
      	 /* If this was the last item in the list, the browse window and menu
      	    may need some adjusting. */
      	 run adedict/_brwadj.p (INPUT {&OBJ_TBL}, INPUT cnt).
   end.
   else if oldhid AND NOT b_File._Hidden AND NOT s_Show_Hidden_Tbls then
   do:
      /* If hidden was changed to no and Show_Hidden flag is off,
      	 add table to the browse list.  This can only happen if the
      	 table was changed to hidden and then changed back
      	 before switching to any other table.
      */
      find FIRST dictdb._File where dictdb._File._Db-recid = s_DbRecId AND
			     dictdb._File._File-Name > b_File._File-name AND
			     (dictdb._File._Owner = "PUB" OR dictdb._File._Owner = "_FOREIGN") AND
      	       	     	     NOT dictdb._File._Hidden
	       	     	     NO-ERROR.
      
      nxtname = (if AVAILABLE dictdb._File then dictdb._File._File-name else "").
      run adedict/_newobj.p
      	 (INPUT s_lst_Tbls:HANDLE in frame browse,
	  INPUT b_File._File-name,
	  INPUT nxtname,
	  INPUT s_Tbls_Cached,
	  INPUT {&OBJ_TBL}).
   end.
   else if oldname <> newname AND 
      	NOT (b_File._Hidden AND NOT s_Show_Hidden_Tbls) then
   do:
      /* If name was changed and the table is currently showing 
      	 change the name in the browse list.
         If there's more than one table, delete and re-insert to
      	 make sure the new name is in alphabetical order.
      */
      if s_lst_Tbls:NUM-ITEMS in frame browse > 1 then
      do:
       	 s_Res = s_lst_Tbls:delete(oldname) in frame browse.

      	 /* Put in non case-sensitive variable for next search. */
      	 ins_name = newname.  
      	 {adedict/TBL/nexttbl.i &Name = ins_name
      	       	     	      	&Next = nxtname}
      	 run adedict/_newobj.p
	    (INPUT s_lst_Tbls:HANDLE in frame browse,
	     INPUT ins_name,
	     INPUT nxtname,
	     INPUT s_Tbls_Cached,
	     INPUT {&OBJ_TBL}).
      end.
      else do:
	 /* Change name in place in browse window list */
	 {adedict/repname.i
	    &OldName = oldname
	    &NewName = newname
	    &Curr    = s_CurrTbl
	    &Fill    = s_TblFill
   	    &List    = s_lst_Tbls}
      end.
   end.

   {adedict/setdirty.i &Dirty = "true"}.
   /* If we just made the last table hidden, the property sheet may be
      gone (from brwadj.p)!  So we'd better check before doing this.
   */
   do with frame tblprops:
       /* disable the multi-tenant check-boxs if [1] was set to true */  
       if b_File._File-Attributes[1] and b_File._File-Attributes[1]:sensitive then
       do:
           b_File._File-Attributes[1]:sensitive = false.
           b_File._File-Attributes[2]:sensitive = false.
       end.
       if b_File._File-Attributes[3] and b_File._File-Attributes[3]:sensitive then
       do:
           b_File._File-Attributes[3]:sensitive = false.
       end.
       if s_win_Tbl <> ? then
           display "Table modified" @ s_Status.
       run adecomm/_setcurs.p ("").
   end.
   return "".
   
end.

run adecomm/_setcurs.p ("").
return "error".



