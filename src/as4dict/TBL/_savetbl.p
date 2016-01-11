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

File: _savetbl.p

Description:
   Save any changes the user made in the table property window. 

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Laura Stern

Date Created: 07/14/92
            Modified to run with PROGRESS/400 Data Dictionary 1995 D. McMann
            07/25/96 Added assignment of _fil-misc2[5][1] = Y  D. McMann
            03/25/97 Added assignment of p__Index._For-type to = format name of file.
                     97-03-13-087 D. McMann
            06/26/97 Added reserve and dba_unres = false when table has new name or new
                     library 96-09-26-005 D. McMann  
            08/22/97 Added check outside of new name for format name change 97-08-22-013 D. McMann
                            
----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{as4dict/TBL/tblvar.i shared}

Define var oldname  as char CASE-SENSITIVE NO-UNDO.
Define var newname  as char CASE-SENSITIVE NO-UNDO.
Define var oldaname as char                                     NO-UNDO.
Define var newaname as char                                  NO-UNDO.
 Define var oldlib       as char                                         NO-UNDO.
Define var newlib    as char                                         NO-UNDO.
Define var junk     as logical       	   NO-UNDO.
Define var no_name  as logical 	       	   NO-UNDO.
Define var cnt      as integer             NO-UNDO.
Define var oldhid   as logical             NO-UNDO.
Define var nxtname  as char                NO-UNDO.
Define var ins_name as char                NO-UNDO.
Define var fnlngth as integer                                    NO-UNDO.

current-window = s_win_Tbl.

/* Check if name is blank and return if it is */
run as4dict/_blnknam.p
   (INPUT b_File._File-Name:HANDLE in frame tblprops,
    INPUT "table", OUTPUT no_name).
if no_name then return "error".
   
assign
   oldname = b_File._File-Name
   newname = input frame tblprops b_File._File-Name
   oldhid  = 
      if b_File._Hidden = "Y" then yes else no.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   run adecomm/_setcurs.p ("WAIT").

   /* Do old/new name check if new as4-file or library change save old for apply. */           
    ASSIGN   
        oldaname = b_File._AS4-File
        newaname =   CAPS(input frame tblprops s_AS400_File_name )
        oldlib = b_File._AS4-Library
        newlib =    CAPS(input frame tblprops s_AS400_Lib_Name).
        
   if (oldaname <> newaname and oldlib = newlib) OR
       (oldaname <> newaname and oldlib <> newlib) OR
       (oldaname = newaname and oldlib <> newlib) then  do:  
       
       /* new file getting new name */
       IF b_File._Fil-Misc1[4] = 0 THEN DO:
            ASSIGN dba_cmd = "UNRESERVE".
            RUN as4dict/_dbaocmd.p 
              (INPUT "PF", 
 	        INPUT oldaname,
       	  INPUT oldlib,
       	  INPUT 0,
       	  INPUT 0).              
        END.                                                       
        /* Existing file getting first new name */
        ELSE IF b_File._Fil-Res2[8] = ? OR b_File._Fil-res2[8] = "" THEN DO:	                        
            assign fnlngth = LENGTH(oldaname).

            if fnlngth < 10 then  do:
                define var fillchar as character format "x" initial  " " NO-UNDO.            
                assign b_File._Fil-Res2[8] = b_File._AS4-File +  FILL(fillchar, 10 - fnlngth)  +   b_File._AS4-Library.
           end.
            else assign b_File._Fil-Res2[8] = b_File._AS4-File +   b_File._AS4-Library.    
        END.
       /* Existing getting another new name unreserve  placeholder so it will not be left after apply */
        ELSE DO:
            ASSIGN dba_cmd = "UNRESERVE".
            RUN as4dict/_dbaocmd.p 
	      (INPUT "PF", 
	       INPUT oldaname,
      	       INPUT oldlib,
	       INPUT 0,
	       INPUT 0).              
        END.                                                                      
        ASSIGN dba_cmd = "RESERVE".
        RUN as4dict/_dbaocmd.p 
	      (INPUT "PF", 
	       INPUT newaname,
      	       INPUT newlib,
	       INPUT 0,
	       INPUT 0).              
         ASSIGN dba_unres = false.
         
        for each as4dict.p__Field where as4dict.p__Field._File-number = b_File._File-number:
            assign as4dict.p__Field._AS4-File =  newaname
                          as4dict.p__Field._AS4-Library = newlib.
         end.
        for each as4dict.p__Index where as4dict.p__Index._File-number = b_File._File-number:
            assign as4dict.p__Index._I-Misc2[6] = newlib + "/" + newaname.                  
        end.                                                                       
    end.                                              
    IF CAPS(input frame tblprops b_File._For-format) <> b_file._For-Format THEN DO:
       for each as4dict.p__Index where as4dict.p__Index._File-number = b_File._File-number:
            assign as4dict.p__Index._For-type = CAPS(input frame tblprops b_File._For-Format).
       end.                    
    END.   
    /* Any sub-dialog changes (e.g., triggers)  have already been saved.  
       We just need to move main property values into buffer. */
   assign
      b_File._File-Name = newname                       
      b_File._AS4-File = CAPS(input frame tblprops s_AS400_File_Name)
      b_File._AS4-Library = CAPS(input frame tblprops s_AS400_Lib_Name)
      b_File._For-Name = CAPS(input frame tblprops s_AS400_Lib_Name) + "/" + 
          (input frame tblprops s_AS400_File_Name)
      b_File._For-Format = CAPS(input frame tblprops b_File._For-Format)
      input frame tblprops b_File._Dump-Name
      b_File._Hidden = 
          if input frame tblprops s_File_hidden then "Y" else "N"       
      b_File._Frozen =
          if input frame tblprops s_File_Frozen then "Y" else "N"    
      input frame tblprops b_File._For-Size
      input frame tblprops b_File._File-label
      input frame tblprops b_File._Desc    
      b_File._Fil-Misc1[1] = b_File._Fil-Misc1[1] + 1
      b_file._Fil-res1[8] = 1.
      
      /* Verify that file is marked as being last updated in ADE */ 
      IF SUBSTRING(b_File._Fil-misc2[5],1,1) <> "Y" THEN
          ASSIGN SUBSTRING(b_File._Fil-misc2[5],1,1) = "Y".
      
      IF b_File._Fil-res1[7] < 0 then assign b_File._Fil-res1[7] = 0. 


   if s_Tbl_Type:sensitive in frame tblprops then
      b_File._For-type = input frame tblprops s_Tbl_Type.
  
   if NOT oldhid AND s_File_Hidden AND NOT s_Show_Hidden_Tbls then
   do:
      /* If hidden was changed to yes, and Show_Hidden flag is off, 
      	 remove the table from the browse window table list. */
      run adecomm/_delitem.p (INPUT s_lst_Tbls:HANDLE in frame browse, 
      	       	     	     INPUT oldname, OUTPUT cnt).
      apply "value-changed" to s_lst_Tbls in frame browse.
      if cnt = 0 then
      	 /* If this was the last item in the list, the browse window and menu
      	    may need some adjusting. */
      	 run as4dict/_brwadj.p (INPUT {&OBJ_TBL}, INPUT cnt).
   end.
   else if oldhid AND NOT s_File_Hidden AND NOT s_Show_Hidden_Tbls then
   do:
      /* If hidden was changed to no and Show_Hidden flag is off,
      	 add table to the browse list.  This can only happen if the
      	 table was changed to hidden and then changed back
      	 before switching to any other table.
      */
      find FIRST as4dict.p__File where as4dict.p__File._File-Name > b_File._File-name AND
      	       	     	     as4dict.p__File._Hidden = "N"
	       	     	     NO-ERROR.
      
      nxtname = (if AVAILABLE as4dict.p__File then as4dict.p__File._File-name else "").
      run as4dict/_newobj.p
      	 (INPUT s_lst_Tbls:HANDLE in frame browse,
	  INPUT b_File._File-name,
	  INPUT nxtname,
	  INPUT s_Tbls_Cached,
	  INPUT {&OBJ_TBL}).
   end.
   else if oldname <> newname AND 
      	NOT (s_File_Hidden AND NOT s_Show_Hidden_Tbls) then
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
      	 {as4dict/TBL/nexttbl.i &Name = ins_name
      	       	     	      	&Next = nxtname}
      	 run as4dict/_newobj.p
	    (INPUT s_lst_Tbls:HANDLE in frame browse,
	     INPUT ins_name,
	     INPUT nxtname,
	     INPUT s_Tbls_Cached,
	     INPUT {&OBJ_TBL}).
      end.
      else do:
	 /* Change name in place in browse window list */
	 {as4dict/repname.i
	    &OldName = oldname
	    &NewName = newname
	    &Curr    = s_CurrTbl
	    &Fill    = s_TblFill
   	    &List    = s_lst_Tbls}
      end.
   end.

   {as4dict/setdirty.i &Dirty = "true"}.
   /* If we just made the last table hidden, the property sheet may be
      gone (from brwadj.p)!  So we'd better check before doing this.
   */
   if s_win_Tbl <> ? then
      display "Table modified" @ s_Status with frame tblprops.     
      
   /* Must force release of record to DataServer but do not want to loose record so
        issue a validate with no-error.  */
   VALIDATE b_file NO-ERROR.      
   run adecomm/_setcurs.p ("").
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".


