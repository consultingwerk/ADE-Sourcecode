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

File: _newidx.p

Description:
   Display and handle the add index dialog box and then add the index
   if the user presses OK.

Author: Laura Stern

Date Created: 04/22/92
           Updated: 09/20/95 to work with AS/400 Data Dictionary D. McMann
           Modified: 10/31/95 to correct problem with place holders being left on 400
                                               and help with server bug.  D. McMann     
                     03/21/96 To correct bug 96-01-31-056 moved where CHKF was being
                              done.  D. McMann   
                     03/18/97 To correct length of index to less than 200 D. McMann
                              97-03-18-060    
                     04/17/97 Removed call to isdata.i to determine if any data
                              is contained within a file to checking the _Fil-misc1[4]
                              field to know if the file has been created.  This stops
                              the server from openning the file which causes the commit
                              to fail if the unique index is the physical file key.
                              96-11-04-007  D. McMann
                     06/24/97 Added Word Index Support D. McMann   
                     08/06/97 Removed comments now that valwrdidx command is ready D. McMann     
                     08/13/97 Made A/D disabled if word index 97-08-12-025 D. McMann
                     08/16/00 D. McMann Added Raw Data Type Support                                    
----------------------------------------------------------------------------*/


{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{as4dict/IDX/idxvar.i shared}
{as4dict/capab.i}

/* General processing variables */
Define var num_flds  as integer NO-UNDO. /* # of index flds chosen */
Define var max_flds  as integer NO-UNDO.
Define var capab     as char   	NO-UNDO.
Define var all_cnt   as integer NO-UNDO.
Define var added     as logical NO-UNDO INIT no.    
Define var chgname AS LOGICAL INITIAL FALSE NO-UNDO.

Define buffer x_File for as4dict.p__File.


/*=========================Internal Procedures===============================*/

/*-----------------------------------------------------------------
   Remove the selected field name from one list and add it
   to the other.

   Input Parameters:
      p_lst_Add  - Handle of selection list to add the name to.
      p_lst_Rmv  - Handle of selection list to remove name from.
      p_To_Index - True, if the field is being added to the index or
      	       	   false if field is being removed from the index.
------------------------------------------------------------------*/
PROCEDURE Transfer_Name:

Define INPUT parameter p_lst_Add  as widget-handle NO-UNDO.
Define INPUT parameter p_lst_Rmv  as widget-handle NO-UNDO.
Define INPUT parameter p_To_Index as logical       NO-UNDO.

Define var fldname as char    NO-UNDO.
Define var cnt 	   as integer NO-UNDO.
Define var pos     as integer NO-UNDO.
Define var nxtname as char    NO-UNDO.
Define var ix      as integer NO-UNDO.  /* loop index */

   /* Get the selected name from the "remove list". */
   fldname = p_lst_Rmv:screen-value.

   /* Remove this name from the "remove list" */
   run adecomm/_delitem.p (INPUT p_lst_Rmv, INPUT fldname, OUTPUT cnt).

   if p_To_Index then
   do:
      /* Add ascending/descending marker.  For Word indexes, this 
      	 isn't relevant 
      */
      fldname =  STRING(input frame newidx s_IdxFld_AscDesc, "x(3)")
      	        + fldname.
      
      /* Index field order is in the order they are added. */
      s_Res = p_lst_Add:ADD-LAST(fldname). 
   end.
   else do:
      /* Remove ascending/descending marker */
      fldname = SUBSTR(fldname, 4, 32).

      /* Insert field back in it's proper place.  Determine the position
      	 this field took in original field list.  Look from this point
      	 down in original list until we find an entry that is still in
      	 the left hand field list.  This is the entry we want to insert
      	 above.
      */
      pos = LOOKUP(fldname, s_lst_IdxFldChoice:private-data in frame newidx).
      do ix = pos + 1 to all_cnt:
      	 nxtname = ENTRY(ix, s_lst_IdxFldChoice:private-data in frame newidx).
      	 if p_lst_Add:LOOKUP(nxtname) <> 0
      	    then leave.
      end.      
      if ix > all_cnt then
      	 s_Res = p_lst_Add:ADD-LAST(fldname). 
      else
      	 s_Res = p_lst_Add:INSERT(fldname, nxtname).
   end.

   /* Select the fldname value, making sure it's in view. */
   p_lst_Add:screen-value = fldname.
   run adecomm/_scroll.p (INPUT p_lst_Add, INPUT fldname).
end.


/*-----------------------------------------------------------------
   Move an entry down or up in the index fields list.

   Input Parameters:
      p_Incr - Amount to add to the list position to get the new
      	       position (either 1 or - 1).
      p_Down - True if moving down, False if moving up.

------------------------------------------------------------------*/
PROCEDURE Move_Entry:

Define INPUT parameter p_Incr as integer       NO-UNDO.
Define INPUT parameter p_Down as logical       NO-UNDO.

Define var lst_flds as widget-handle NO-UNDO.
Define var pos      as integer 	     NO-UNDO.
Define var fldname  as char   	     NO-UNDO.

   lst_flds = s_lst_IdxFlds:HANDLE in frame newidx. /* for convenience */

   /* Get the selected name from the list. */
   fldname = lst_flds:screen-value.
   
   /* Get the position of the item to insert in front of.  If moving down
      this will be +1 - actually, we want to insert in front of the one 2
      slots down but that will be only one slot down once this one is 
      removed.  If moving up, this will be -1.	
   */
   pos = lst_flds:LOOKUP(fldname) + p_Incr.

   /* Delete the item */
   s_Res = lst_flds:DELETE(fldname).

   if p_Down AND pos > num_flds - 1 then /* - 1 'cause of item just deleted */
      s_Res = lst_Flds:ADD-LAST(fldname).
   else if NOT p_Down AND pos = 0 then
      s_Res = lst_Flds:ADD-FIRST(fldname).
   else
      s_Res = lst_Flds:INSERT(fldname, lst_Flds:ENTRY(pos)).

   /* Select the fldname value, making sure it's in view. */
   lst_Flds:screen-value = fldname.
   run adecomm/_scroll.p (INPUT lst_Flds, INPUT fldname).

   /* Move up and down buttons may need enabling/disabling */
   run Adjust_Move_Btns.
end.


/*-----------------------------------------------------------------
   Adjust the sensitive-ness of the "Move Up" and "Move Down" buttons.
   There must be at least 2 items in the list for these to make
   sense.  Also, if the last item is selected, disable Move Down.
   Similarly, if the first item is selected, disable Move Up.

------------------------------------------------------------------*/
PROCEDURE Adjust_Move_Btns:

Define var val as char NO-UNDO.

   val = s_lst_IdxFlds:screen-value in frame newidx.

   s_btn_IdxFldDwn:sensitive in frame newidx = 
      (if num_flds > 1 AND 
       val <> s_lst_IdxFlds:ENTRY(num_flds) in frame newidx then
       yes else no).	 
   s_btn_IdxFldUp:sensitive in frame newidx = 
      (if num_flds > 1 AND 
       val <> s_lst_IdxFlds:ENTRY(1) in frame newidx then
       yes else no).	 
end.


/*-----------------------------------------------------------------
   Add the currently selected field to the list of index fields.
------------------------------------------------------------------*/
PROCEDURE Add_Field:
   Define var val as char NO-UNDO.

   run Transfer_Name (INPUT s_lst_IdxFlds:HANDLE in frame newidx,
      	       	      INPUT s_lst_IdxFldChoice:HANDLE in frame newidx,
      	       	      INPUT true).

   num_flds = num_flds + 1.

   /* Now that we know there's at least one index field, user can
      remove fields or set the asc/desc flag */
   assign
      s_lst_IdxFlds:sensitive in frame newidx = yes
      s_btn_IdxFldRmv:sensitive in frame newidx = yes.
      
      if NOT input frame newidx s_Idx_Word then
         s_IdxFld_AscDesc:sensitive in frame newidx = yes.

   /* Move-Up and move-down buttons may need enabling/disabling */
   run Adjust_Move_Btns.

   /* Can only support up to max_flds fields in an index.  Also if there's
      no fields left to add, disable add button. */
   if ( num_flds = max_flds OR
        s_lst_IdxFldChoice:NUM-ITEMS in frame newidx = 0) then
      s_btn_IdxFldAdd:sensitive in frame newidx = no.
end.


/*--------------------------------------------------------------------
   Remove the currently selected field from the list of index fields.
---------------------------------------------------------------------*/
PROCEDURE Remove_Field:
   run Transfer_Name (INPUT s_lst_IdxFldChoice:HANDLE in frame newidx,
      	       	      INPUT s_lst_IdxFlds:HANDLE in frame newidx,
      	       	      INPUT false).

   num_flds = num_flds - 1.

   if num_flds = 0 then
      assign
      	 s_lst_IdxFlds:sensitive in frame newidx = no
      	 s_IdxFld_AscDesc:sensitive in frame newidx = no
      	 s_btn_IdxFldRmv:sensitive in frame newidx = no.

   /* Move up and down buttons may need enabling/disabling */
   run Adjust_Move_Btns.
   
   if num_flds < max_flds then
      /* Make sure add button is sensitive now. */
      s_btn_IdxFldAdd:sensitive in frame newidx = yes.
end.


/*===============================Triggers====================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame newidx   
do:      
   apply "END-ERROR" to frame newidx.
end.

/*----- HIT of OK BUTTON -----*/
on choose of s_btn_OK in frame newidx
   s_OK_Hit = yes.               
 
   /* The GO trigger will fire after this. */

/*----- HIT of ADD (Index) BUTTON or GO -----*/
on GO of frame newidx	/* or Create - because it's auto-go */
do:
   Define var fnum   	as integer NO-UNDO.
   Define var flds   	as char    NO-UNDO.
   Define var name   	as char    NO-UNDO.
   Define var id     	as integer   NO-UNDO.
   Define var primary 	as logical NO-UNDO.
   Define var defname   as char    NO-UNDO.
   Define var wordidx   as logical NO-UNDO.
   Define var answer    as logical NO-UNDO.
   Define var no_name   as logical NO-UNDO.
   Define var ins_name  as char    NO-UNDO.
   Define var is_data   as logical NO-UNDO.
   Define var tmpfile   as char    NO-UNDO.
   Define var xnum_proc as char    NO-UNDO.       
   Define var lngth-idx as integer  NO-UNDO.  
   Define var wordidxsize as integer NO-UNDO.
   Define var oksize as logical no-undo.
   Define var char_fld as logical INITIAL YES NO-UNDO.
   
    run as4dict/_blnknam.p
        (INPUT b_Index._Index-name:HANDLE in frame newidx,
        INPUT "index", OUTPUT no_name).
    if no_name then do:
        s_OK_Hit = no.
        return NO-APPLY.
    end.
    if num_flds = 0 then do:
        message "You must specify at least one field" SKIP
            "for the index."
        view-as ALERT-BOX ERROR  buttons OK.    
        s_OK_Hit = no.
        return NO-APPLY.
    end.     

    wordidx = input frame newidx s_Idx_Word.
    
    IF NOT CAN-FIND(FIRST as4dict.p__Field where as4dict.p__Field._File-number = x_File._File-number 
               and as4dict.p__Field._Data-Type = "character") THEN
       char_fld = no.

   /* Check to see if another index has name */
    if NOT wordidx AND can-find(as4dict.p__Index where 
      as4dict.p__Index._AS4-File =   CAPS(input frame newidx b_Index._AS4-file) 
      AND as4dict.p__Index._AS4-Library = CAPS(input frame newidx b_Index._AS4-Library) )
    then   do:         
        message "An logical file with this name already exists in this library."
        view-as ALERT-BOX ERROR buttons OK.               
        s_OK_Hit = no.
        return NO-APPLY.
    end.          
    /* Check to see if another file has this name */
    If NOT wordidx AND can-find(as4dict.p__file where
        as4dict.p__File._AS4-FIle =   CAPS(input frame newidx b_Index._AS4-file) 
        AND as4dict.p__File._AS4-Library = CAPS(input frame newidx b_Index._AS4-Library) )
    then   do:         
        message "A physical file with this name already exists in this library."
             view-as ALERT-BOX ERROR buttons OK.               
        s_OK_Hit = no.
        return NO-APPLY.
    end.  
  
    flds = s_lst_IdxFlds:LIST-ITEMS in frame newidx. /* Get all fields in list */

    if wordidx = yes then do:
      if num_flds > 1 then do:
 	  message "An index that is word-indexed" SKIP
	 	   "can only have one field component." 
      	    view-as ALERT-BOX ERROR  buttons OK.    
      	  s_OK_Hit = no.
	  return NO-APPLY.
       end.

      /* Since we don't allow primary, unique or abbreviated to be on
      	 when Word indexed is chosen, or vice versa, we don't need to 
      	 check that.
      */

      name = SUBSTR(flds, 4, 32).  /* We know now there's only 1 fld */
     
      find as4dict.p__Field where as4dict.p__Field._File-number = s_TblForNo
                              and as4dict.p__Field._Field-Name = name.
      if as4dict.p__Field._Data-Type <> "Character" then
      do:
	 message "You can only specify word-indexed when" SKIP
		 "the index contains a character field."
      	    view-as ALERT-BOX ERROR  buttons OK.    
      	 s_OK_Hit = no.
	 return NO-APPLY.
      end.    
    END. 
    ASSIGN lngth-idx = 0.
    DO: 
        do fnum = 1 to num_flds:                                                       
            name = SUBSTR(ENTRY(fnum, flds), 4, 32).         
            find as4dict.p__Field where as4dict.p__field._file-number = s_TblForNo
	                                                and as4dict.p__Field._Field-Name = name.
            if as4dict.p__Field._Extent > 0 AND NOT wordidx then do:                 
                message "Array fields are not allowed in Indexes."
                view-as ALERT-BOX ERROR  buttons OK.    
                s_OK_Hit = no.
                return NO-APPLY.
            end.                  
            ASSIGN lngth-idx = lngth-idx + as4dict.p__Field._Fld-stlen. 
        end.
      
        if lngth-idx >= 200 AND NOT wordidx then do:
            message "The length of an index must be less than 200." SKIP
            view-as ALERT-BOX ERROR buttons OK.
            s_OK_Hit = no.
            return NO-APPLY.
        end.
        
        if input frame newidx s_Idx_Abbrev = yes then do:
      	 /* Get last field specified for the index */
            assign name = s_lst_IdxFlds:ENTRY(num_flds) in frame newidx
                   name = SUBSTR(name, 4, 32).

            find as4dict.p__Field where as4dict.p__field._file-number = s_TblForNo
      	         AND as4dict.p__Field._Field-Name = name.
            if as4dict.p__Field._Data-Type <> "Character" then do:
                message "Abbreviate is an index option that lets you" SKIP
      	       	    "conveniently search for a partial match based" SKIP
      	       	    "on the first few characters of a field (like" SKIP
      	       	    "using BEGINS) in the FIND ...USING statement." SKIP(1)
      	       	    "This option is only available on indexes that" SKIP
      	       	    "have a character field as their last index" SKIP
      	       	    "component."
                view-as ALERT-BOX ERROR  buttons OK.    
                s_OK_Hit = no.
                return NO-APPLY.
            end.     
        end.
        if input frame newidx s_Idx_Unique  = yes AND
            input frame newidx s_Idx_Active = yes then do:   

      	 /* Before putting up this horrible message, check to see if
      	    the file has been created yet.  If it has then put up the
      	    message so that the user will know that if data is found and 
      	    is not unique, the AS/400 will rollback all the changes.
      	 */ 
            
            if x_File._fil-misc1[4] > 0 then do:
                answer = yes.   /* set's yes as default button */
                message 
                    "If PROGRESS finds duplicate values while creating" SKIP
                    "this new unique index, it will UNDO the entire" SKIP
                    "transaction, causing you to lose any schema changes" SKIP
                    "made within the same transaction." SKIP(1)
                    "Recommendations:" SKIP(1)
                    "If you are sure there are no duplicate values OR" SKIP
                    "if you did not make any other schema changes within" SKIP
                    "this transaction, then select OK to add this new" SKIP
                    "unique index." SKIP(1)
                    "Otherwise, select Cancel.  You can then close the" SKIP
                    "dialog, commit the transaction (Edit/Commit from the menu)" SKIP
                    "and then add the index." SKIP(1)                    
                    view-as ALERT-BOX WARNING buttons OK-CANCEL update answer.

                if answer = false then do:
                    s_OK_Hit = no.
                    return NO-APPLY.
                end.
            end.
        end.
    end.
    IF NOT wordidx THEN DO:
      dba_cmd = "CHKF".
      RUN as4dict/_dbaocmd.p 
       (INPUT "LF", 
	INPUT CAPS(input frame newidx b_Index._AS4-file),
      	INPUT  CAPS(input frame newidx b_Index._AS4-Library),
	INPUT 0,
	INPUT 0).

      if dba_return =   2 then DO :
        dba_cmd = "RESERVE".
        RUN as4dict/_dbaocmd.p 
        (INPUT "LF", 
	 INPUT input frame newidx b_Index._AS4-file,
      	 INPUT input frame newidx b_Index._AS4-library,
	 INPUT 0,
	 INPUT 0).        	  

        if dba_return <> 12 then DO:
            RUN as4dict/_dbamsgs.p.    
            s_OK_Hit = no.
            return NO-APPLY.
        end.     
      end.         
     /* If object in library give generic error message and return */
      else if dba_return = 1 then do:
        message "A file object with this name already exists in this library."
               view-as ALERT-BOX ERROR buttons OK.               
        s_OK_Hit = no.
        return NO-APPLY.
      end.              
      else do:
        RUN as4dict/_dbamsgs.p.    
        s_OK_Hit = no.
        return NO-APPLY.   
      end. 
    END.
    ELSE DO:
      dba_cmd = "VALWRDIDX".
      RUN as4dict/_dbaocmd.p 
       (INPUT "", 
	 INPUT CAPS(x_File._AS4-file),
      	 INPUT  CAPS(x_File._AS4-Library),
	 INPUT 0,
	 INPUT 0).

      IF dba_return <> 1 THEN DO:
        message "The *USRSPC " + CAPS(x_File._AS4-File) +
           " already exists in library " CAPS(x_File._AS4-Library) + "."
            view-as ALERT-BOX ERROR buttons OK.               
        s_OK_Hit = no.
        return NO-APPLY.

          
      END.

      dba_cmd = "CHKOBJ".
      RUN as4dict/_dbaocmd.p 
       (INPUT "*USRIDX", 
	 INPUT CAPS(input frame newidx b_Index._AS4-File),
      	 INPUT  CAPS(input frame newidx b_Index._AS4-Library),
	 INPUT 0,
	 INPUT 0).

      if dba_return = 1 THEN DO:
        message "The *USRIDX " + CAPS(input frame newidx b_Index._AS4-File) +
        " already exists in library " CAPS(input frame newidx b_Index._AS4-Library) + "."
               view-as ALERT-BOX ERROR buttons OK.               
        s_OK_Hit = no.
        return NO-APPLY.
      end.              
    end.      
       
    do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p ("WAIT").
  
      assign
	 input frame newidx b_Index._Index-name   
	 b_Index._AS4-file = CAPS(input frame newidx b_Index._AS4-file)
	 b_Index._AS4-Library = CAPS(input frame newidx b_Index._AS4-Library)
	 b_Index._Unique = 
	     (if input frame newidx s_Idx_Unique then "Y" else "N")
	 b_Index._Wordidx = 
	     (if input frame newidx s_Idx_Word then 1 else 0)
	 b_Index._Active = 
	     (if input frame newidx s_Idx_Active then "Y" else "N")
	      input frame newidx b_Index._Desc
	 b_Index._I-Res1[1] = input frame newidx word_size.   

             /* Fill AS4-File fields and AS4-Library fields in p__index. */
  
    
        assign 
             b_Index._I-Misc2[6]  = substring(x_File._For-name,1, 25)
             b_Index._For-name    = b_Index._AS4-library + "/" + b_Index._As4-File
             b_Index._For-type    = x_File._For-format 
             b_Index._num-comp = num_flds 
             x_File._Fil-Misc1[1] = x_File._Fil-Misc1[1] + 1
             x_File._Fil-Res1[8] = 1             
             x_File._numkey = x_File._numkey + 1.            
             
        IF x_File._Fil-res1[7] < 0 then assign x_File._Fil-res1[7] = 0. 
                
      /* Create a record for each index field. */
        do fnum = 1 to num_flds:
            name = SUBSTR(ENTRY(fnum, flds), 4, 32).      
            find as4dict.p__Field where as4dict.p__field._file-number = s_TblForNo
      	      AND as4dict.p__Field._Field-Name = name.

            if as4dict.p__Field._Fld-stdtype = 41 then
                  assign as4dict.p__Field._Fld-misc2[8] = "Y".
                       
            create as4dict.p__IdxFd.
            assign as4dict.p__IdxFd._IDX-NUM =  b_Index._Idx-num
                    as4dict.p__IdxFd._Fld-number = as4dict.p__Field._Fld-number
                    as4dict.p__IdxFd._Index-seq   = fnum    
                    as4dict.p__IdxFd._AS4-file    = b_Index._AS4-file
                    as4dict.p__IdxFd._AS4-Library = b_Index._As4-Library
                    as4dict.p__IdxFd._File-number = as4dict.p__Field._File-number
                    as4dict.P__IdxFd._If-misc2[1] = as4dict.p__Field._Fld-misc2[2]  
                    as4dict.p__IdxFd._If-misc2[2] = substring(as4dict.p__Field._For-name,1,10)
                    as4dict.p__IdxFd._Abbreviate  = (if fnum = num_flds then 
                        (if input frame newidx s_Idx_Abbrev then "Y" else "N")
                         else "N")
                    as4dict.p__IdxFd._Ascending =
                       (if SUBSTR(ENTRY(fnum, flds), 1, 1) = "A" then "Y" else "N").
            IF as4dict.p__Idxfd._If-misc2[1] = "Y" THEN
                ASSIGN b_Index._I-Misc2[4] = "NNYYYYYNN".
            ELSE ASSIGN b_Index._I-Misc2[4] = "NNNYYYYNN".        
      	 
            if as4dict.p__Field._Fld-stdtype = 41 then
                assign as4dict.p__Idxfd._If-misc2[7] = "Y".   
                       
	   /* Indicate if Index has case sensitive field in it */
            IF as4dict.p__Field._Fld-Misc2[6] = "A" AND as4dict.p__Field._Fld-case = "Y" THEN
                ASSIGN b_Index._I-Misc2[4] = SUBSTRING(b_Index._I-Misc2[4],1,9) + "Y".
        end.
     
        /*If this is the first index created then set the prime-index to this index user
            can change later if they want.  */

        /* If there is no primary index, or the the user explicitly wants
      	 this index to be the primary one, set the primary index flag 
      	 in the p__File record. 
        */            
            
        if x_File._Prime-Index = -1 then primary = yes.
        else primary = no.
 
        if (primary OR input frame newidx s_Idx_Primary = yes) then DO:
            IF x_File._Prime-index = -1 THEN
                ASSIGN SUBSTRING(b_Index._I-Misc2[4],9,1) =  "Y"
                        x_File._Prime-Index = b_Index._Idx-num 
                        x_file._Fil-misc1[7] = b_Index._Idx-num
                        s_Status = " - Created Primary Index".         
          	           
            ELSE IF x_File._Prime-index <> b_Index._Idx-num THEN DO:
                MESSAGE "Do you want the key to the physical file" SKIP
                              "changed to this primary index key?" SKIP
                              VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
                IF answer THEN DO:              
                    FIND as4dict.p__Index WHERE as4dict.p__Index._File-number = x_File._file-number
                                                              AND as4dict.p__Index._Idx-num = x_File._Fil-misc1[7].    
                    IF x_file._Fil-res1[7] <= 0 THEN DO:    
                        dba_cmd = "CHKF".
                        RUN as4dict/_dbaocmd.p 
                            (INPUT "LF", 
                            INPUT as4dict.p__Index._AS4-File,
                            INPUT  as4dict.p__Index._AS4-Library,
                            INPUT 0,
                            INPUT 0).

                        IF dba_return =   2 then DO :
                            dba_cmd = "RESERVE".
                            RUN as4dict/_dbaocmd.p 
                                (INPUT "LF", 
                                INPUT as4dict.p__Index._AS4-File,
                                INPUT as4dict.p__Index._AS4-Library,
                                INPUT 0,
                                INPUT 0).      
                            chgname = true.
                        END.        
	   /* Can't use the AS4-file name since it is not unique for library  get new one*/
                        ELSE  
                            RUN as4dict/IDX/_chgprme.p (OUTPUT chgname).  
                    end.
                    else assign chgname = true.
	   
                    IF chgname THEN  DO:                       
	       /* Only assign if key of file has not been changed during this session.  Apply
	           needs to know the old index which was key to the file */   
         
                        IF x_File._Fil-Res1[7] <= 0 THEN
                            ASSIGN x_File._Fil-Res1[7]  = x_File._Fil-misc1[7].
                        
                        ASSIGN  SUBSTRING(as4dict.p__Index._I-misc2[4],9,1) = "N" 
                            as4dict.p__Index._I-Res1[4] = 1
                            SUBSTRING(b_Index._I-misc2[4],9,1) = "Y"
                            x_File._Prime-index = b_Index._Idx-num 
                            x_File._Fil-Misc1[1] = x_File._Fil-Misc1[1] + 1                                   
                            x_file._Fil-misc1[7] = b_Index._Idx-num   
                            s_Status = "- Made this the primary index".     
                    END.                                        
                    ELSE    
                        ASSIGN  SUBSTRING(b_Index._I-Misc2[4],9,1) = "N".                                        
                END.   
                
                ELSE    
                    ASSIGN  SUBSTRING(b_Index._I-Misc2[4],9,1) =  "N".             
            END.  
            ASSIGN x_File._Prime-index = b_Index._Idx-num.
        END.                                 
        ELSE     
            ASSIGN SUBSTRING(b_Index._I-Misc2[4],9,1) =  "N"          
                s_Status = "".        
      
        /* Add entry to indexes list in alphabetical order */
        find FIRST as4dict.p__Index where as4dict.p__Index._File-number = s_TblForNo AND
      	     	      	      as4dict.p__Index._Index-Name > b_Index._Index-Name 
                                NO-ERROR.

        ins_name = (if AVAILABLE as4dict.p__Index then as4dict.p__Index._Index-name else "").
        run as4dict/_newobj.p
         (INPUT s_lst_Idxs:HANDLE in frame browse,
          INPUT b_Index._Index-name,
          INPUT ins_name,
          INPUT s_Idxs_Cached,
          INPUT {&OBJ_IDX}).
   
        {as4dict/setdirty.i &Dirty = "true"}.
        display "Index Created" + s_Status @ s_Status with frame newidx.
        added = yes.
        run adecomm/_setcurs.p ("").  
        ENABLE s_Idx_Primary
               s_Idx_word when char_fld and allow_word_idx
               with frame newidx. 
        return.
    end.

   /* Only get here if there's an error.  Leave box up and let the user
      fix the problem or Cancel. */
    run adecomm/_setcurs.p ("").   
    s_OK_Hit = no.
    return NO-APPLY.
end.


/*----- HIT of ADD >> (add field) BUTTON -----*/
on choose of s_btn_IdxFldAdd in frame newidx
   run Add_Field.


/*----- DEFAULT-ACTION (DBL-CLICK or RETURN) of FIELD CHOICE LIST -----*/
on default-action of s_lst_IdxFldChoice in frame newidx
   run Add_Field.


/*----- HIT of REMOVE >> (remove field) BUTTON -----*/
on choose of s_btn_IdxFldRmv in frame newidx 
   run Remove_Field.


/*----- HIT of MOVE DOWN BUTTON -----*/
on choose of s_btn_IdxFldDwn in frame newidx 
   run Move_Entry(1, TRUE).


/*----- HIT of MOVE UP BUTTON -----*/
on choose of s_btn_IdxFldUp in frame newidx 
   run Move_Entry(-1, FALSE).


/*----- DEFAULT-ACTION (DBL-CLICK or RETURN) of INDEX FIELD LIST -----*/
on default-action of s_lst_IdxFlds in frame newidx
   run Remove_Field.

/*----- VALUE-CHANGED of WORD INDEX TOGGLE -----*/
on value-changed of s_Idx_Word in frame newidx
do:
   Define var ix     	as integer NO-UNDO.
   Define var sel    	as char    NO-UNDO.
   Define var olditem 	as char    NO-UNDO.
   Define var newitem 	as char    NO-UNDO.
   
   if SELF:screen-value = "yes" then 
   do:
      /* If user turns word indexing on, turn off primary, unique and
      	 abbreviated and disable ascending/descending. 
      */
      assign
	 s_Idx_Primary:screen-value in frame newidx = "no"
	 s_Idx_Unique:screen-value in frame newidx = "no"
	 s_Idx_Abbrev:screen-value in frame newidx = "no"
      	 s_IdxFld_AscDesc:screen-value in frame newidx = "A"
      	 s_IdxFld_AscDesc:sensitive in frame newidx = no.
      	 
      	 Enable word_size with frame newidx.
       
      /* Also set all the Asc/Desc flags to "A" */
      sel = s_lst_IdxFlds:screen-value in frame newidx.
      do ix = 1 to s_lst_IdxFlds:num-items:
      	 olditem = s_lst_IdxFlds:entry(ix) in frame newidx.
      	 if SUBSTR(olditem, 1, 1) = "D" then
      	 do:
      	    assign
      	       newitem = olditem
      	       SUBSTR(newitem, 1, 1) = "A"
      	       s_Res = s_lst_IdxFlds:replace(newitem, olditem) in frame newidx.
      	    if olditem = sel then
      	       s_lst_IdxFlds:screen-value in frame newidx = newitem.
      	 end.
      end.
      apply "entry" to word_size in frame newidx.
   end.
   else do:
         /* Enable Asc/Desc if there are any fields in the list */
      if s_lst_IdxFlds:num-items > 0 then 
      	 s_IdxFld_AscDesc:sensitive in frame newidx = yes.
      disable word_size with frame newidx.	 
   end.   
end.

/*----- LEAVE OF word_size ---------------*/
on leave of word_size in frame newidx
do:
  if input frame newidx word_size  < 10 OR input  frame newidx word_size > 128 THEN DO:
    message "Size of word must be between 10 and 128"
      view-as alert-box error.
    return no-apply.
  end.    
end.
/*----- VALUE-CHANGED of ASC/DESC RADIO SET -----*/
on value-changed of s_IdxFld_AscDesc in frame newidx  
do:
   Define var oldval as char NO-UNDO.
   Define var newval as char NO-UNDO.

   assign
      oldval = s_lst_IdxFlds:screen-value in frame newidx
      newval = STRING(TRIM(SELF:screen-value), "x(3)") + SUBSTR(oldval, 4, 32).

   s_Res = s_lst_IdxFlds:replace(newval, oldval) in frame newidx = no.
   s_lst_IdxFlds:screen-value in frame newidx = newval.  /* reset selection */
end.

/*----- VALUE-CHANGED of PRIMARY TOGGLE -----*/
on value-changed of s_Idx_Primary in frame newidx
do:
   /* Primary and word indexed are incompatible */
   if SELF:screen-value = "yes" then do:
      s_Idx_Word:screen-value in frame newidx = "no".
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.
       
      disable word_size with frame newidx.
   end.
end.


/*----- VALUE-CHANGED of UNIQUE TOGGLE -----*/
on value-changed of s_Idx_Unique in frame newidx
do:
   /* Unique and word indexed are incompatible */
   if SELF:screen-value = "yes" then do:
      s_Idx_Word:screen-value in frame newidx = "no".
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.
      disable word_size with frame newidx.
   end.
end.


/*----- VALUE-CHANGED of ABBREVIATED TOGGLE -----*/
on value-changed of s_Idx_Abbrev in frame newidx
do:
   /* Abbreviated and word indexed are incompatible */
   if SELF:screen-value = "yes" then do:
      s_Idx_Word:screen-value in frame newidx = "no".
      s_IdxFld_AscDesc:sensitive in frame newidx = yes.
      disable word_size with frame newidx.
   end.
end.




/*----- VALUE-CHANGED of INDEX FIELDS LIST -----*/
on value-changed of s_lst_IdxFlds in frame newidx
do:
   /* Reflect ascending/descending value for this entry in radio set. */
      s_IdxFld_AscDesc:screen-value in frame newidx = 
      	 substr(SELF:screen-value, 1, 1).

   /* Move up and down buttons may need enabling/disabling */
   run Adjust_Move_Btns.
end.


/*----- HELP -----*/
on HELP of frame newidx OR choose of s_btn_Help in frame newidx
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", {&AS4_Create_Index_Dlg_Box}, ?).


/*============================Mainline code==================================*/

Define var frstfld  as char       NO-UNDO init "".
Define var char_fld as logical    NO-UNDO init yes.
Define var cmax     as char       NO-UNDO.
Define var access   as logical    NO-UNDO.
Define var msg as char            NO-UNDO.      

find FIRST as4dict.p__Field WHERE as4dict.p__field._File-number = s_TblForNo
                              AND as4dict.p__Field._Dtype <> 8 NO-ERROR.
if NOT AVAILABLE as4dict.p__Field then
do:
   message "You must first create fields for this" SKIP
      	   "table before you can create an index."
      view-as ALERT-BOX ERROR  buttons OK.
   return.
end.

find x_File where x_File._File-number = s_TblForNo.
if x_File._Frozen = "Y" then  
do:
   message "This file is frozen and cannot be modified."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.              

IF  SUBSTRING(x_File._Fil-misc2[4],8,1) = "Y" THEN DO:   
     if x_file._For-flag = 1 then msg = "Limited logical virtual table, can't modify".
     else if x_file._For-flag = 2 then msg = "Multi record virtual table, can't modify".
     else if x_file._For-flag = 3 then msg = "Joined logical virtual table, can't modify".
     else if x_file._For-flag = 4 then msg = "Program described virtual table, can't modify".
     else if x_file._For-flag = 5 then msg = "Multi record program described virtual, can't modify".
     else msg = "Read only file, can't be modified via client". 
  
     message msg SKIP view-as ALERT-BOX ERROR buttons OK.
     return.
end.            


IF NOT s_ReadOnly THEN DO:  
    dba_cmd = "CHKF".
    RUN as4dict/_dbaocmd.p 
	 (INPUT "PF", 
	  INPUT x_File._AS4-File,
      	  INPUT x_File._AS4-Library,
	  INPUT 0,
	  INPUT 0).     
  
    IF dba_return = 1 THEN DO:
            dba_cmd = "RESERVE".
            RUN as4dict/_dbaocmd.p 
	 (INPUT "PF", 
	  INPUT x_File._AS4-File,
      	  INPUT x_File._AS4-Library,
	  INPUT 0,
	  INPUT 0).    

            IF dba_return <> 1 THEN DO:
                RUN as4dict/_dbamsgs.p.    
                RETURN. 
            END.
    END.
    ELSE  DO:
            RUN as4dict/_dbamsgs.p.   
            RETURN.
    END.
END.        
  
/* Set dialog box title to show which table this index will belong to. */
frame newidx:title = "Create Index for Table " + s_CurrTbl.

/* Get the max # of components that can be in the index for this gateway */
run as4dict/_capab.p (INPUT {&CAPAB_IDXMAX}, OUTPUT cmax).
max_flds = INTEGER(cmax).

/* Determine if the word indexed and abbreviated fields should be sensitive.
   They will be if there are any character fields in this table. */
find FIRST as4dict.p__Field where as4dict.p__Field._File-number = x_File._File-number 
                              and as4dict.p__Field._Data-Type = "character" NO-ERROR.
if NOT AVAILABLE as4dict.p__Field then
   char_fld = no.

/* Run time layout for button area.  Since this is a shared frame we have 
   to avoid doing this code more than once.
*/
if frame newidx:private-data <> "alive" then
do:
   frame newidx:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame newidx" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget. */
   b_Index._Desc:RETURN-INSERT in frame newidx = yes.
end.

/*
   Explicitly disable based on these conditions in case these were
   sensitive from the last time round.  Then conditionally enable (using
   ENABLE verb) below to make sure the TAB order comes out right.
*/

if NOT char_fld then
   ASSIGN s_Idx_Abbrev:sensitive in frame newidx = no
          s_Idx_Word:sensitive in frame newidx = no.

s_Status = "".
display s_Status with frame newidx. /* erases val from the last time */
s_btn_Done:label in frame newidx = "Cancel".
 IF x_File._Prime-Index > 0 then 
    enable s_Idx_Primary 
           s_Idx_word when char_fld and allow_word_idx
           with frame newidx.
 else do:
      s_Status = "This will be primary index".
      disable s_Idx_word with frame newidx.
 end.
 enable b_Index._Index-Name      
       b_Index._AS4-File       
       b_Index._AS4-Library
       b_Index._Desc
       s_Idx_Active
       s_Idx_Unique
       s_Idx_Abbrev when char_fld
       s_lst_IdxFldChoice
       s_btn_IdxFldAdd
       s_btn_OK
       s_btn_Add
       s_btn_Done
       s_btn_Help
        with frame newidx.

/* Since we will be enabling/disabling various widgets as the user adds/deletes
   fields from the index, and since we don't want to ENABLE all widgets up
   front (and then immediately disable them), we can't rely on enable to 
   set the TAB order properly.  Reset the tab position for all un-enabled
   widgets which may become sensitized as user users the frame.
*/
assign
   s_Res = s_btn_IdxFldRmv:move-after-tab-item 
      	       (s_btn_IdxFldAdd:handle in frame newidx) in frame newidx
   s_Res = s_btn_IdxFldDwn:move-after-tab-item 
      	       (s_btn_IdxFldRmv:handle in frame newidx) in frame newidx
   s_Res = s_btn_IdxFldUp:move-after-tab-item 
      	       (s_btn_IdxFldDwn:handle in frame newidx) in frame newidx
   s_Res = s_lst_IdxFlds:move-after-tab-item 
      	       (s_btn_IdxFldUp:handle in frame newidx) in frame newidx
   s_Res = s_IdxFld_AscDesc:move-after-tab-item 
      	       (s_lst_IdxFlds:handle in frame newidx) in frame newidx
   s_Res = word_size:move-after-tab-item 
      	       (s_Idx_word:handle in frame newidx) in frame newidx
  
   .

/* Each add will be a subtransaction */
s_OK_Hit = no.
add_subtran:
repeat ON ERROR UNDO,LEAVE  ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   /* Do this up top here, to be sure we committed the last create */
   if s_OK_Hit then leave add_subtran.

   if added AND s_btn_Done:label in frame newidx <> "Close" then
      s_btn_Done:label in frame newidx = "Close".
 
   assign reserved = false.
   create b_Index.                                                                                                                                      
   
   ASSIGN b_Index._File-number = x_file._File-number    
          b_Index._Idx-num = (x_file._fil-Res1[2] + 1) 
          b_Index._AS4-Library = x_file._AS4-Library
          x_file._Fil-Res1[2] = x_File._Fil-res1[2] + 1.
   
   num_flds = 0.

   /* Have to display all fields, so on 2nd or 3rd add, any entered values
      will be cleared. */             
   
   IF x_File._Prime-Index = -1 then s_Idx_Primary = yes.
   else s_Idx_Primary = no.
      
   assign
      s_Idx_Active = yes
      s_Idx_Unique = no
      s_Idx_Word = no
      word_size = (IF allow_word_idx then 10 else 0)
      s_IdxFld_AscDesc = "A"
      s_Idx_Abbrev = no.

   /* Clear and refill the field list in the appropriate sort order */
   s_lst_IdxFldChoice:LIST-ITEMS in frame newidx = "".
   s_lst_IdxFldChoice:private-data in frame newidx = "".
   run as4dict/_fldlist.p
      (INPUT   s_lst_IdxFldChoice:HANDLE in frame newidx,
       INPUT   s_TblRecId,
       INPUT   (if s_Order_By = {&ORDER_ALPHA} then true else false),
       INPUT   "",
       INPUT   "RAW",
       INPUT   no,
       INPUT   "",
       OUTPUT  access).
   if NOT access then undo add_subtran, leave add_subtran.

   assign
      /* Keep a comma separated list of the original contents of this list.
      	 Keep it in private data since if we put it in a regular variable
      	 we run out of variable space when the database is very big.  
      	 Private data is in different data space.
      */
      s_lst_IdxFldChoice:private-data in frame newidx = 
      	 s_lst_IdxFldChoice:LIST-ITEMS in frame newidx
      all_cnt = NUM-ENTRIES(s_lst_IdxFldChoice:private-data in frame newidx)
      s_lst_IdxFlds:LIST-ITEMS in frame newidx = "" /* clear the list */
   
      /* Reset sensitiveness of widgets */
      s_lst_IdxFlds:sensitive in frame newidx = false
      s_btn_IdxFldAdd:sensitive in frame newidx = true
      s_btn_IdxFldRmv:sensitive in frame newidx = false
      s_btn_IdxFldDwn:sensitive in frame newidx = false
      s_btn_IdxFldUp:sensitive in frame newidx = false
      word_size:sensitive in frame newidx = false.

   display "" @ b_Index._Index-Name /* blank instead of ? */  
           "" @ b_Index._AS4-File     
          b_Index._AS4-Library
      	   s_Idx_Primary
          s_Idx_Active
          s_Idx_Unique
          s_Idx_Word
          word_size WHEN allow_word_idx
          s_Idx_Abbrev
      	   s_lst_IdxFldChoice
      	   s_lst_IdxFlds
      	   s_IdxFld_AscDesc
          b_Index._Desc    
          s_status
       with frame newidx.

   /* Set selection to first item in list of fields */
   s_lst_IdxFldChoice:screen-value in frame newidx =
      s_lst_IdxFldChoice:entry(1) in frame newidx.

   wait-for choose of s_btn_OK in frame newidx,
      	              s_btn_Add in frame newidx OR
      	    GO of frame newidx
      	    FOCUS b_Index._Index-Name in frame newidx.
end.

/* Reset private data to free memory - it could be big */
s_lst_IdxFldChoice:private-data in frame newidx = "".

hide frame newidx.
return.







