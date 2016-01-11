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

File: _newtbl.p

Description:
   Display and handle the add table dialog box and then add the table
   if the user presses OK.

   Note: Currently only Progress and CTOSISAM files added through this 
   code.  All others are created via a gateway utility.  However, this is
   is set up to work for all gateways. 

Author: Laura Stern

Date Created: 03/13/92

History:

Modified on 7/8/94 by gfs - Bug 94-06-14-177 (again)
Modified on 7/7/94 by gfs - Bug 94-06-14-177
Modified on 12/23/94 by DLM  for AS400 dictionary       
Modified on 10/25/96 by DLM to remove enable of _Frozen
Modified on 03/21/97 by DLM changed default library to OBJECTLIB 97-01-20-020
----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{adecomm/cbvar.i shared}
{as4dict/TBL/tblvar.i shared}
{as4dict/capab.i}


Define var capab as char    NO-UNDO.
Define var added as logical NO-UNDO INIT no.
Define var numerr as logical NO-UNDO.    

/*===============================Triggers====================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame newtbl       
   apply "END-ERROR" to frame newtbl.


/*----- HIT of OK BUTTON -----*/
on choose of s_btn_OK in frame newtbl
   s_OK_Hit = yes.
   /* The GO trigger will fire after this. */

/*----- HIT of DONE BUTTON ------- */
on choose of s_btn_done in frame newtbl
do:                          
  IF dba_unres THEN DO:             
    dba_cmd = "UNRESERVE".
    RUN  as4dict/_dbaocmd.p 
	 (INPUT " ", 
	  INPUT CAPS(input frame newtbl s_AS400_File_name),
      	  INPUT CAPS(input frame newtbl s_AS400_Lib_name),
	  INPUT 0,
	  INPUT 0).     
	  
    IF dba_return <> 1 THEN
         MESSAGE "Problem with unreserve " + string(dba_return)
         view-as alert-box information button ok.	  
    end.         
     if numerr then do:
       hide frame newtbl.
       return.
    end.
end.
	       
/*----- HIT of OK BUTTON or ADD BUTTON or GO -----*/
on GO of frame newtbl	/* or buttons - because they're auto-go */
do:
   Define var no_name  as logical NO-UNDO.
   Define var nxtname  as char    NO-UNDO.

   run as4dict/_blnknam.p
      (INPUT b_File._File-name:HANDLE in frame newtbl,
       INPUT "table", OUTPUT no_name).
   if no_name then do:
      s_OK_Hit = no.  /* in case ok was hit */
       return NO-APPLY.
   end.           
   
  find first as4dict.p__File
      where as4dict.p__File._Dump-name = input frame newtbl b_File._Dump-name
          AND as4dict.p__File._File-number <> b_File._File-number
      NO-ERROR.
   if AVAILABLE as4dict.p__File then  do:
     s_OK_Hit = no.
     return NO-APPLY.
   end.
     
  IF NOT  dba_unres THEN DO:     
    define var lname as character.
    define var okay as logical.
    define var who_fail as character.
     
    run as4dict/_libnam.p (INPUT s_AS400_Lib_Name, INPUT s_win_Tbl,  
                                               INPUT input frame newtbl s_AS400_File_name,
      	       	     	   OUTPUT lname, OUTPUT okay).       
   if okay then dba_unres = true.   	       	     	  
   else do:
        assign s_Valid = no
                      s_OK_Hit = no.
        return NO-APPLY.              
    end.
  end.
     
   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p ("WAIT").
      
      IF NOT s_Show_Hidden_Tbls AND input frame newtbl s_File_Hidden THEN DO:
            ASSIGN MENU-ITEM mi_Show_Hidden:CHECKED in MENU s_mnu_View = TRUE.
            APPLY "VALUE-CHANGED" TO MENU-ITEM mi_Show_Hidden in MENU s_mnu_View.
      END.

      assign
         input frame newtbl b_File._File-name 
         b_File._As4-File = CAPS(input frame newtbl s_AS400_File_name)
         b_File._AS4-Library = CAPS(input frame newtbl s_AS400_Lib_name )
         b_File._For-name = CAPS(input frame newtbl s_AS400_Lib_name) + "/" +
                           CAPS(input frame newtbl s_AS400_File_name)
 	 input frame newtbl b_File._Dump-Name
	 b_File._Hidden = 
	    if input frame newtbl s_File_Hidden then "Y" else "N"  	
	 input frame newtbl b_File._File-label
	 input frame newtbl b_File._Desc   
	 input frame newtbl b_File._For-format                        
	 b_File._For-number = b_file._File-number
	 b_File._Prime-index = -1	 
	 b_File._Can-Create = "*"
	 b_File._Can-Delete = "*"
	 b_File._Can-Dump = "*"
	 b_File._Can-Load = "*"
	 b_File._Can-Read = "*"
	 b_File._Can-Write = "*"
	 b_file._Db-recid = 1.
     
      if s_Tbl_Type:sensitive in frame newtbl then
      	 b_File._For-type = input frame newtbl s_Tbl_Type.   

/* _Fil-misc2[4] is a list of flags for the AS400.  The bits mean: 
       1 - triggers, 2 constraints, 3 - null indicator, 4-7 can read, write
       update, delete, 8 - read only
       
    _Fil-misc2[4] bit 3 may be changed when fields are added if any allow
    nulls but will initially be set to N    */
       
    ASSIGN b_File._Fil-Misc2[4] = "NNNYYYNN".
                                    	 
/* The origin of the file is the client, store this information in
  Fil-Misc2[5]  */  
   Assign b_File._Fil-Misc2[5] = "Y".        
   
 /* Set the index indicator to -1 until primary index is set */
 
   Assign b_File._Fil-misc1[7] = -1.    
              
/*  Make sure the current table number is re-set   */
   Assign s_tblForNo = b_file._For-number.
      
 /* Add entry to tables list in alphabetical order */

      if s_Show_hidden_Tbls OR NOT s_File_Hidden then
      do:
      	 {as4dict/TBL/nexttbl.i &Name = b_File._File-Name  
      	       	     	      	&Next = nxtname}
	 run as4dict/_newobj.p
	    (INPUT s_lst_Tbls:HANDLE in frame browse,
	     INPUT b_File._File-name,
	     INPUT nxtname,
	     INPUT s_Tbls_Cached,
	     INPUT {&OBJ_TBL}).
      end.

      {as4dict/setdirty.i &Dirty = "true"}.
      display "Table Created" @ s_Status with frame newtbl.
      added = yes.
      run adecomm/_setcurs.p ("").
      return.
   end.

   /* We only get here if an error occurred. Dialog box should remain   */

   run adecomm/_setcurs.p ("").
   s_OK_Hit = no.
   return NO-APPLY.  
end.


/*----- LEAVE of CREATE BUTTON -----*/
on LEAVE of s_btn_Add in frame newtbl
   display "" @ s_Status with frame newtbl. /* clear status line */


/*----- HELP -----*/
on HELP of frame newtbl OR choose of s_btn_Help in frame newtbl
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", {&AS4_Create_Table_Dlg_Box}, ?).


/*============================Mainline code==================================*/
/* Get the as4dict.p__Db record so it can be used to find where the objects
   should be placed. */
find first as4dict.p__db NO-LOCK.   

/* Make stuff appropriate for add visible, and other stuff invisible */
assign
   s_Tbl_IdxCnt:hidden in frame newtbl = yes.

/* Since this is a shared frame we have to avoid doing this code more
   than once.
*/
if frame newtbl:private-data <> "alive" then
do:
   frame newtbl:private-data = "alive".

   /* Run time layout for button area.  This defines eff_frame_width */
   {adecomm/okrun.i  
      &FRAME = "frame newtbl" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }
   
   /* So Return doesn't hit default button in editor widget. */
   b_File._Desc:RETURN-INSERT in frame newtbl = yes.
   
   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_optional:width-chars in frame newtbl = eff_frame_width - ({&HFM_WID} * 2).
end.

/* Erase any status from the last time */
s_Status = "".
display s_Status with frame newtbl.
s_btn_Done:label in frame newtbl = "Cancel".   


/* Default the value of the p__Db.OBJECTLIB */
s_AS400_Lib_Name = caps(as4dict.p__DB.OBJECTLIB).

/* Default the label of the AS400 File Name to be physical.  */
s_AS400_File_Name:LABEL in frame newtbl = "Physical Filename".

s_Tbl_Type = s_DbCache_Type[s_DbCache_ix].

/* Each add will be a subtransaction */
s_OK_Hit = no.    

add_subtran:
repeat ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   /* Do this up top here, to be sure we committed the last create */
   if s_OK_Hit then leave add_subtran.

   if added AND s_btn_Done:label in frame newtbl <> "Close" then
      s_btn_Done:label in frame newtbl = "Close".
   dba_unres = no.             
   /* Get new file number  from AS400 sequence generator */
   
    dba_cmd = "GETNUM".
    RUN  as4dict/_dbaocmd.p 
	 (INPUT " ", 
	  INPUT " ",
      	  INPUT as4dict.p__Db._Db-name,
	  INPUT 0,
	  INPUT 0).          
  
  /* Check dba_return to make sure a file number has been gotten.  If the number is
       greater or equal to 32600 no more files can be created or a problem has occurred
       and a number can not be generated */
       
   IF dba_return >= 32600 THEN DO:     
     MESSAGE  "The sequence generator for file numbers in the server schema"
                            "library is either missing or is locked.  A new file can not be"
                            "generated."
                  VIEW-AS ALERT-BOX ERROR BUTTON OK.     
         assign numerr = true.          
         enable s_btn_done with frame newtbl.         
        APPLY "CHOOSE" to s_btn_Done in frame newtbl.       
    END.                  

   create b_File.                   
   assign 	 b_File._File-number =  dba_return .        
   
/* moved enable statement to behind the create statement to avoid */
/* problems with buffer b_File <hutegger, 94/02/03> */
/* Note: the order of enables will govern the TAB order. */

   enable 
       b_File._File-Name
       s_AS400_File_Name
       s_AS400_Lib_Name
       b_File._Dump-Name
       s_Tbl_Type          when INDEX(capab, {&CAPAB_TBL_TYPE_ADD}) > 0
       b_File._File-label
       b_File._Desc            
       b_File._For-Format
       s_File_Hidden
       s_btn_Tbl_Triggers
       s_btn_Tbl_Validation
       s_btn_Tbl_StringAttrs
       s_btn_OK
       s_btn_Add
       s_btn_Done
       s_btn_Help
       with frame newtbl.

/* Have to display all fields, so on 2nd or 3rd add, any entered values
      will be cleared. */
   display "" @ b_File._File-Name   /* display blank instead of ? */
           "" @ s_AS400_File_Name   
           "" @ b_File._For-format
             s_AS400_Lib_Name
      	   s_optional
      	   s_Tbl_Type
      	   "" @ b_File._Dump-Name
      	   s_File_Hidden
      	   s_File_Frozen
      	   b_File._File-label
      	   b_File._Desc
      	   b_File._For-Size  when INDEX(capab, {&CAPAB_TBL_SIZE}) > 0
      	   b_File._For-format
      	   with frame newtbl.

   wait-for choose of s_btn_OK, s_btn_Add in frame newtbl OR
      	    GO of frame newtbl
      	    FOCUS b_File._File-Name in frame newtbl.
end.                                        

hide frame newtbl.
  
if s_OK_Hit  then /* but not Create */
      apply "choose" to MENU-ITEM mi_Crt_Field in MENU s_mnu_Create.  
 

return.



