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

File: _idxprop.p

Description:
   Set up the index properties window so the user can view or modify the 
   information on an index.  Since this window is non-modal, we just do the
   set up here.  All triggers must be global.

Author: Laura Stern

Date Created: 04/29/92

Last modified on:

08/26/94 by gfs     Added Recid index support.
Modified to run with PROGRESS/400 Data Dictionary 1995 D. McMann
12/03/96 by DLM changed assignment and size of labels
06/24/97 by DLM Added word index support
08/14/97 by DLM Fixed 97-08-12-006 disable AS-FILE name when physical file key
----------------------------------------------------------------------------*/


{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{as4dict/IDX/idxvar.i shared}
{as4dict/capab.i}

Define var err 	     as logical NO-UNDO.
Define var capab     as char    NO-UNDO.
Define var frstfld   as char	NO-UNDO init "".
Define var lst_item  as char	NO-UNDO.
Define var name_mod  as logical NO-UNDO. /* name modifiable */      
Define var ronote    as char           NO-UNDO. /* read only virtual file note */

/*============================Mainline code==================================*/

/* Don't want Cancel if moving to next index - only when window opens */
if s_win_Idx = ? then
   s_btn_Close:label in frame idxprops = "Cancel".

/* Open the window if necessary */
run as4dict/_openwin.p
   (INPUT   	  "AS/400 Index Properties",
    INPUT   	  frame idxprops:HANDLE,
    INPUT         {&OBJ_IDX},
    INPUT-OUTPUT  s_win_Idx).

/* Run time layout for button area. Since this is a shared frame we 
   have to avoid doing this code more than once.
*/
if frame idxprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      s_win_Idx:width = s_win_Idx:width + 1
      frame idxprops:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame idxprops" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget */
   b_Index._Desc:RETURN-INSERT in frame idxprops = yes.
end.

/* First clear the select list in case it had stuff in it from the last time. */
s_lst_IdxFlds:LIST-ITEMS = "".

CLEAR FRAME idxprops ALL NO-PAUSE.

find as4dict.p__file where as4dict.p__File._For-number = s_TblForNo.
find b_Index where b_Index._file-number = s_TblForNo 
        AND b_Index._Index-Name = s_CurrIdx.
if as4dict.p__File._Prime-Index = b_Index._Idx-num then s_Idx_Primary = yes.
else
   s_Idx_Primary = no.                 
if b_Index._Wordidx = 1 then
  assign word_size = b_Index._I-Res1[1].
else
  assign word_size = 0.  
if word_size = 0 THEN 
  DISABLE word_size WITH FRAME idxprops.  
find LAST as4dict.p__IdxFd where as4dict.p__idxfd._File-number = s_TblForNo
                             and as4dict.p__Idxfd._Idx-num = b_Index._Idx-num NO-ERROR.
if AVAILABLE as4dict.p__IdxFd then 
   s_Idx_Abbrev = (if as4dict.p__IdxFd._Abbreviate = "Y" then yes else no).

 ASSIGN ActRec:LABEL = "Active"
            ActRec       = If b_Index._Active = "Y" then yes else no.
            
 /* Set status line */
display "" @ s_Status ActRec with frame idxprops. /* clears from last time */

if NOT s_ReadOnly then
do:
   if as4dict.p__File._Frozen = "Y" then
   do:
     DISPLAY "Note: This file is frozen and cannot be modified." @ s_Status
	 with frame idxprops.
      s_Idx_ReadOnly = true.
   end.       
   ELSE IF SUBSTRING(as4dict.p__File._Fil-misc2[4],8,1) = "Y" THEN DO:          
        if as4dict.p__file._For-flag = 1 then ronote = "Limited logical virtual table, can't modify".
       else if as4dict.p__file._For-flag = 2 then ronote = "Multi record virtual table, can't modify".
       else if as4dict.p__file._For-flag = 3 then ronote = "Joined logical virtual table, can't modify".
       else if as4dict.p__file._For-flag = 4 then ronote = "Program desc virtual table, can't modify".
       else if as4dict.p__file._For-flag = 5 then ronote = "Multi record pgm desc virtual, can't modify".
       else ronote = "Read only file, can't be modified via client". 
        DISPLAY  ronote @ s_Status
              with frame idxprops.
        ASSIGN s_Idx_ReadOnly = true.       
   END.     
   ELSE IF SUBSTRING(b_Index._I-Misc2[4],8,1) = "Y" THEN DO:
        ronote = "Read only file, can't be modified via client".        
        DISPLAY  ronote @ s_Status
              with frame idxprops.
        ASSIGN s_Idx_ReadOnly = true.  
   END.            
   ELSE  DO:
        dba_cmd =  "CHKF".
        RUN as4dict/_dbaocmd.p 
	 (INPUT "PF", 
	  INPUT as4dict.p__file._AS4-File,
      	  INPUT as4dict.p__File._AS4-Library,
	  INPUT 0,
	  INPUT 0).     
	  
        IF dba_return = 2 THEN DO:    
            DEFINE VARIABLE redofile AS LOGICAL INITIAL TRUE.
            MESSAGE "The AS400 physical file does not exist for this"
                                  "index.   Should the physical file be re-created?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS yes-no UPDATE redofile .                     
            IF redofile THEN 
                ASSIGN as4dict.p__file._For-owner = "".
             ELSE RETURN.   
        END.   
        ELSE IF dba_return <> 1 THEN DO:
            RUN as4dict/_dbamsgs.p.  
            DISPLAY "Note: DBA error index cannot be modified." @ s_Status
               with frame idxprops.
              s_Idx_ReadOnly = true.
        END.     
        ELSE DO:
             dba_cmd = "RESERVE".
            RUN as4dict/_dbaocmd.p 
	 (INPUT "PF", 
	  INPUT as4dict.p__file._AS4-File,
      	  INPUT as4dict.p__File._AS4-Library,
	  INPUT 0,
	  INPUT 0).     
	  
            IF dba_return <> 1 THEN DO:
                display "Note: File in use index cannot be modified." @ s_Status
      	 with frame idxprops.
                 ASSIGN s_idx_ReadOnly = true.    
             END.   
             else s_Idx_ReadOnly = false.
        END.                                                          
            
        IF SUBSTRING(b_Index._I-misc2[4], 9,1) <> "Y"  AND dba_return = 1 AND
           b_Index._WordIdx <> 1 THEN DO:   
            dba_cmd =  "CHKF".
            RUN as4dict/_dbaocmd.p 
	    (INPUT "LF", 
            INPUT b_Index._AS4-file,
      	     INPUT b_Index._AS4-Library,
	     INPUT 0,
	     INPUT 0).             
            /* found logical file */
            If dba_return = 1 THEN DO:
                dba_cmd = "RESERVE".
                RUN as4dict/_dbaocmd.p 
	          (INPUT "LF", 
	           INPUT b_Index._AS4-File,
      	           INPUT b_Index._AS4-Library,
	           INPUT 0,
	           INPUT 0).    
	  
                IF dba_return <> 1 THEN DO:
                    display "Note: Index in use, cannot be modified." @ s_Status
      	                with frame idxprops.
                    ASSIGN s_idx_ReadOnly = true.  
               END.     
               ELSE s_Idx_ReadOnly = false.          
            END.  
            ELSE If dba_return = 2 AND b_Index._Active <> "N" THEN DO:
                MESSAGE "Logical file not found, you must delete the index"
                                          "information and re-create for file object to be"
                                          "created."
                           VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                ASSIGN  s_idx_Readonly = true.
            END.    
            ELSE IF b_Index._Active = "N" AND dba_return = 2 THEN.                           	  
            ELSE DO:        
                RUN as4dict/_dbamsgs.p.    
                display "Note: Index cannot be modified." @ s_Status
      	 with frame idxprops.
                ASSIGN s_idx_ReadOnly = true.  
             END.       
        END.     
         
    END.            
END.   
ELSE s_Idx_ReadOnly = (s_DB_ReadOnly OR s_ReadOnly).                                 
/* Fill in Alternate Sequence Table and Alternate Sequence Library
from the as4dict.p__file record.  */                    

/* Setup field list and it's labels */
s_txt_List_Labels[1] = STRING(" ", "x(45)") + "A(sc)/".
s_txt_List_Labels[2] = STRING("Index Field", "x(34)") +
                       STRING("Data Type", "x(11)") +
                       "D(esc)".

/* Fill up the list of index fields  skipping extra case insensitive fields */
for each as4dict.p__IdxFd where  as4dict.p__Idxfd._File-number = as4dict.p__file._File-number
                            and  as4dict.p__idxfd._Idx-num = b_Index._Idx-num
                            and as4dict.p__Idxfd._If-misc2[8] <> "Y":
   find as4dict.p__Field where   as4dict.p__Field._File-number = as4dict.p__File._File-number
                           and as4dict.p__Field._Fld-number = as4dict.p__IdxFd._Fld-number .
                           
   lst_item = STRING(as4dict.p__Field._Field-Name, "x(34)") + 
      	      STRING(as4dict.p__Field._Data-type, "x(11)").

   lst_item = lst_item + (if as4dict.p__IdxFd._Ascending = "Y" then " A" else " D").

   s_Res = s_lst_IdxFlds:add-last(lst_item) in frame idxprops.

   if frstfld = "" then
      frstfld = lst_item.
end.
s_lst_IdxFlds:screen-value = frstfld.  /* set selection to the first fld */

/*  Setup value for logical form field (toggle boxes)  */
s_Idx_Unique = 
      (if b_Index._Unique = "Y" then yes else no).  
      
s_Idx_Word = (if b_Index._Word = 1 then yes else no).          	
               	   
display b_Index._Index-Name
        b_Index._AS4-file	
        b_Index._AS4-Library 
        b_Index._Desc 
   	 s_Idx_Primary
    	 ActRec
    	 s_Idx_Unique
        s_Idx_Word
   	 s_Idx_Abbrev
        word_size WHEN word_size > 0
      	 s_txt_List_Labels[1]
        s_txt_List_Labels[2]
   with frame idxprops.

if s_Idx_ReadOnly then
do:
   disable all except
	  s_lst_IdxFlds 
	  s_btn_Close 
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame idxprops.            
	  
   enable s_lst_IdxFlds 
	   s_btn_Close 
	   s_btn_Prev
	   s_btn_Next
	   s_btn_Help
	   with frame idxprops.            

   apply "entry" to s_btn_Close in frame idxprops.
end.
else do:
   /* Get gateway capabilities */
   run as4dict/_capab.p (INPUT {&CAPAB_IDX}, OUTPUT capab).

   /* Note: In Progress, you change the primary index by setting this one to
      be primary but you can't make a primary index be not-primary.  You
      can make an index inactive but not active - that is done via proutil. 
      In some gateways, making inactive and changing primary aren't allowed
      at all.

      Explicitly disable based on these conditions in case these were
      sensitive from the last index, and then conditionally enable (using
      ENABLE verb) below to make sure the TAB order comes out right.
   */
  
      name_mod = true.

   if s_Idx_Primary  OR s_Idx_Word then
      s_Idx_Primary:sensitive in frame idxprops = no.

    ActRec:sensitive in frame idxprops = yes.       
         
    s_Idx_Unique:sensitive in frame idxprops = no.
    s_Idx_Word:sensitive in frame idxprops = no.
        
   enable b_Index._Index-Name when name_mod 
      	   b_Index._Desc 
      	   s_Idx_Primary   when NOT s_Idx_Primary AND NOT s_Idx_Word         	      
    	   ActRec
	   s_lst_IdxFlds  
      	   s_btn_OK
	   s_btn_Save
	   s_btn_Close
	   s_btn_Prev
	   s_btn_Next
      	   s_btn_Help
      with frame idxprops.
 
   IF SUBSTRING(b_Index._I-Misc2[4],9,1) = "N"
     THEN enable b_Index._AS4-file 
                 b_Index._AS4-Library
                 with frame idxprops.                  
     ELSE
       DISABLE b_Index._AS4-file 
               b_Index._AS4-Library
               with frame idxprops.
         
   
   IF b_Index._I-Misc1[1] = 0 AND b_Index._Wordidx = 1 THEN
     enable word_size WITH FRAME idxprops.
        
       if name_mod then
      apply "entry" to b_Index._Index-Name in frame idxprops.
   else
      apply "entry" to b_Index._Desc in frame idxprops.
end.

return.




