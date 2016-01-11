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

File: _tblprop.p

Description:
   Display table properties for the current table in the edit window.

Author: Laura Stern

Date Created: 03/16/92     
    Modified: 11/94 converted for use in PROGRESS/400 Data Dictionary NH
              01/06/94 DLM removed substring of for-name, now have fields
                       in p__files. 
              10/25/96 DLM Removed enable of _Frozen.           

----------------------------------------------------------------------------*/


{as4dict/dictvar.i shared}
{as4dict/uivar.i shared}
{as4dict/TBL/tblvar.i shared}
{as4dict/capab.i}


/*----------------------------Mainline code----------------------------------*/

Define var name_editable as logical NO-UNDO.
Define var capab     	 as char    NO-UNDO.
Define var junk	     	 as logical NO-UNDO.
Define var ronote                  as character NO-UNDO.

/* Don't want Cancel if moving to next table - only when window opens */
if s_win_Tbl = ? then
   s_btn_Close:label in frame tblprops = "Cancel".

/* Open the window if necessary */
run as4dict/_openwin.p
   (INPUT   	  "AS/400 Table Properties",
    INPUT   	  frame tblprops:HANDLE,
    INPUT         {&OBJ_TBL},
    INPUT-OUTPUT  s_win_Tbl).
 
/* Run time layout for button area.  This defines eff_frame_width.
   Since this is a shared frame we have to avoid doing this code more
   than once.
*/
if frame tblprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      frame tblprops:private-data = "alive"
      s_win_Tbl:width = s_win_Tbl:width + 1.  

   {adecomm/okrun.i  
      &FRAME = "frame tblprops" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget */
   b_File._Desc:RETURN-INSERT in frame tblprops = yes.

   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_Optional:width-chars in frame tblprops = eff_frame_width - 
      	       	     	      	       	      ({&HFM_WID} * 2).
end.

/* Get the record for the selected table */
find b_file where b_File._File-number = s_TblForNo.

/* Get gateway capabilities */
run as4dict/_capab.p (INPUT {&CAPAB_TBL}, OUTPUT capab). 

/* Figure out what the table type is */
s_Tbl_Type =     
   (
   if b_File._Db-lang = {&TBLTYP_SQL} then
      "PROGRESS/SQL"
   else if b_File._File-Number >= {&TBLNUM_FASTTRK_START} AND
      	   b_File._File-Number <= {&TBLNUM_FASTTRK_END} then
      "FAST TRACK Schema"
   else if b_File._File-Number < 0 then  /* all other negative numbers */
      "PROGRESS Schema"
   else if INDEX(capab, {&CAPAB_TBL_TYPE_MOD}) = 0 then
      /* Only concat on gateway name if user can't change the type */
      s_DbCache_Type[s_DbCache_ix] + " " /* gateway type */
   else ""
   ) + 
   (
   if b_File._For-Type = ? then
      ""
   else 
      b_File._For-Type
   ).                                                    

    s_AS400_file_name = b_File._AS4-File.
    s_AS400_lib_name = b_file._as4-library.

/*  Figure out if we have a Physical or Logical file and set the 
    LABEL attribute for s_AS400_File_name accordingly.  If there
    is a value in _For-Format (AS400 physical file name), then we have 
    a Logical file name.  Otherwise it's just a plain physical file.  */

s_AS400_File_name:LABEL =  
     if b_File._Fil-misc2[6] = ? or b_File._Fil-misc2[6] = "" then
         "Physical Filename"
     else
         "Logical Filename".

s_File_Hidden = 
     if b_File._Hidden = "Y" then yes else no.
     
s_File_Frozen = 
     if b_File._Frozen = "Y" then yes else no.
 
/* Count the number of indexes this table has */
s_Tbl_IdxCnt = 0.
for each as4dict.p__Index where as4dict.p__index._file-Number = b_File._File-number: 
   s_Tbl_IdxCnt = s_Tbl_IdxCnt + 1.
end.


/* Set the status line */
display "" @ s_Status with frame tblprops. /* clears from last time */

IF NOT s_ReadOnly THEN DO:   
    IF b_File._Frozen = "Y"  THEN DO:
        display "Note: This file is frozen and cannot be modified." @ s_Status
      	 with frame tblprops.
        s_Tbl_ReadOnly = true.
    END.            
    ELSE IF SUBSTRING(b_File._Fil-misc2[4],8,1) = "Y" THEN DO:   
        if b_File._For-flag = 1 then ronote = "Limited logical virtual table, can't modify".
       else if b_File._For-flag = 2 then ronote = "Multi record virtual table, can't modify".
       else if b_File._For-flag = 3 then ronote = "Joined logical virtual table, can't modify".
       else if b_File._For-flag = 4 then ronote = "Program desc virtual table, can't modify".
       else if b_File._For-flag = 5 then ronote = "Multi record pgm desc virtual, can't modify".
       else ronote = "Read only file, can't be modified via client". 
       DISPLAY  ronote @ s_Status
           with frame tblprops.
        s_Tbl_ReadOnly = true.
    END.      
    ELSE DO:        
        dba_cmd = "CHKF".
        RUN as4dict/_dbaocmd.p 
	 (INPUT "PF", 
	  INPUT b_file._AS4-File,
      	  INPUT b_File._AS4-Library,
	  INPUT 0,
	  INPUT 0).     

        IF dba_return = 1 THEN DO:
            dba_cmd = "RESERVE".
            RUN as4dict/_dbaocmd.p 
	 (INPUT "PF", 
	  INPUT b_file._AS4-File,
      	  INPUT b_File._AS4-Library,
	  INPUT 0,
	  INPUT 0).     
            IF dba_return = 1 THEN 
                ASSIGN s_Tbl_ReadOnly = false
                                 reserved = true.	  
            ELSE DO:
                DISPLAY "Note: This file is locked and cannot be modified" @ s_Status
      	      with frame tblprops.
                ASSIGN s_Tbl_ReadOnly = true.
            END.       
        END.        	  
        ELSE IF dba_return = 2 THEN DO:    
            DEFINE VARIABLE redofile AS LOGICAL INITIAL TRUE.
            MESSAGE "The AS400 physical file does not exist for this"
                                  "file definition.   Should the physical file be created?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS yes-no UPDATE redofile .                     
            IF redofile THEN DO:  
               dba_cmd = "RESERVE".
               RUN as4dict/_dbaocmd.p 
	           (INPUT "PF", 
	            INPUT b_file._AS4-File,
      	            INPUT b_File._AS4-Library,
	            INPUT 0,
	            INPUT 0).     
               ASSIGN b_file._For-format = ""    
                      s_Tbl_ReadOnly = false
                      reserved = true.
             END.                    
             ELSE  DO:
                HIDE FRAME tblprops NO-PAUSE.      
                 {as4dict/delwin.i &Win = s_win_Tbl &Obj = {&OBJ_TBL}}
                RETURN.                                                 
             END.   
        END.   
        ELSE DO:
            RUN as4dict/_dbamsgs.p.   
             DISPLAY "Note: This file cannot be modified" @ s_Status
      	 with frame tblprops.             
             ASSIGN s_Tbl_ReadOnly = true.
        END.
    END.             	     
 END.
 ELSE ASSIGN s_Tbl_ReadOnly =  s_ReadOnly.   

display  b_File._File-Name
                s_AS400_File_Name
                s_AS400_Lib_Name
      	 s_optional
   	 s_Tbl_Type 
      	 b_File._Dump-Name
      	 s_File_Hidden
   	 s_File_Frozen
      	 b_File._For-Size   
      	 b_File._File-label
                  b_File._Desc
      	 s_Tbl_IdxCnt
                  b_File._For-format     /* Record Format ID */
      	 /* owner */

   with frame tblprops.
      	 
if s_Tbl_ReadOnly then
do:  
   
   disable all except               
	  s_btn_Tbl_Triggers 
	  s_btn_Tbl_Validation 
	  s_btn_Tbl_StringAttrs
	  s_btn_Close 
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame tblprops.   
	  
   enable s_btn_Tbl_Triggers 
	  s_btn_Tbl_Validation 
	  s_btn_Tbl_StringAttrs
	  s_btn_Close 
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help      
	  with frame tblprops.                                         
 
   apply "entry" to s_btn_Tbl_Triggers in frame tblprops.
end.
else do:
   /* User is not allowed to modify the name of a SQL table or a view.  Also 
      some gateways don't allow rename. */
   if b_File._Db-lang = {&TBLTYP_SQL} OR
      CAN-FIND(FIRST _View-ref
	       where _View-ref._Ref-Table = b_File._File-Name) then
      name_editable = false.
   else if INDEX(capab, {&CAPAB_RENAME}) = 0 then
      name_editable = false.
   else
      name_editable = true.
   
   /* Note: the order of enables will govern the TAB order. */
   enable b_File._File-Name   when name_editable
          s_AS400_File_Name
          s_AS400_Lib_Name
	  b_File._Dump-Name
       	  s_Tbl_Type          when INDEX(capab, {&CAPAB_TBL_TYPE_MOD}) > 0
      	  b_File._File-label
	  b_File._Desc
	  s_File_Hidden         
	/*  s_File_Frozen */
	  b_File._For-Size    when INDEX(capab, {&CAPAB_CHANGE_TBL_SIZE}) > 0   
	  b_File._For-format                     
	  s_btn_Tbl_Triggers
	  s_btn_Tbl_Validation
	  s_btn_Tbl_StringAttrs
      	  s_btn_OK
	  s_btn_Save
	  s_btn_Close
      	  s_btn_Prev
      	  s_btn_Next
      	  s_btn_Help
	  with frame tblprops.

   if name_editable then
      apply "entry" to b_File._File-Name in frame tblprops.
   else
      apply "entry" to b_File._Dump-Name in frame tblprops.
end.



