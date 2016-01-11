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

File: _saveprc.p

Description:
   Save any changes the user made in the procedure property window. 

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Donna McMann
Date Created: 05/04/99
     History: 12/30/99  Added check for object
              05/11/00  Put check for object in incorrect place change to
                        only check if screen-values change
            
----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{as4dict/prc/procvar.i shared}

DEFINE VARIABLE oldname  as char CASE-SENSITIVE NO-UNDO.
DEFINE VARIABLE newname  as char CASE-SENSITIVE NO-UNDO.
DEFINE VARIABLE oldaname as char                NO-UNDO.
DEFINE VARIABLE newaname as char                NO-UNDO.
DEFINE VARIABLE oldlib   as char                NO-UNDO.
DEFINE VARIABLE newlib   as char                NO-UNDO.
DEFINE VARIABLE junk     as logical             NO-UNDO.
DEFINE VARIABLE no_name  as logical             NO-UNDO.
DEFINE VARIABLE cnt      as integer             NO-UNDO.
DEFINE VARIABLE nxtname  as char                NO-UNDO.
DEFINE VARIABLE ins_name as char                NO-UNDO.
DEFINE VARIABLE fnlngth  as integer             NO-UNDO.
DEFINE VARIABLE okay     AS LOGICAL             NO-UNDO.

current-window = s_win_Proc.

/* Check if name is blank and return if it is */
run as4dict/_blnknam.p
   (INPUT b_Proc._File-Name:HANDLE in frame prcprops,
    INPUT "procedure", OUTPUT no_name).
if no_name then return "error".
                  
assign oldname = b_proc._File-Name
       newname = input frame prcprops b_proc._File-Name.      

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
  run adecomm/_setcurs.p ("WAIT").

  /* Do old/new name check if new as4-file or library change save old for apply. */           
  ASSIGN oldaname = b_proc._AS4-File
         newaname = CAPS(input frame prcprops s_AS400_Proc_name )
         oldlib = b_proc._AS4-Library
         newlib =    CAPS(input frame prcprops s_AS400_Libr_Name).
        
   if (oldaname <> newaname and oldlib = newlib) OR
      (oldaname <> newaname and oldlib <> newlib) OR
      (oldaname = newaname and oldlib <> newlib) then  do:  
       
          
     RUN as4dict/_chkobj.p
       (INPUT INPUT FRAME prcprops s_AS400_Proc_name,
        INPUT INPUT FRAME prcprops S_AS400_Libr_name,
        INPUT s_win_Proc,
        INPUT "*PGM", 
        OUTPUT okay). 
     
     IF NOT okay THEN  
       RETURN "error".
                                                        
     /* Existing procedure getting first new name */
     IF b_proc._Fil-Res2[8] = ? OR b_proc._Fil-res2[8] = "" THEN DO:	                        
       assign fnlngth = LENGTH(oldaname).

       if fnlngth < 10 then  do:
         define var fillchar as character format "x" initial  " " NO-UNDO.            
         assign b_proc._Fil-Res2[8] = b_proc._AS4-File +  FILL(fillchar, 10 - fnlngth)  +   b_proc._AS4-Library.
       end.
       else assign b_proc._Fil-Res2[8] = b_proc._AS4-File +   b_proc._AS4-Library.    
     END.
     
     for each as4dict.p__Field where as4dict.p__Field._File-number = b_proc._File-number:
       assign as4dict.p__Field._AS4-File =  newaname
              as4dict.p__Field._AS4-Library = newlib.
     end.
     for each as4dict.p__Index where as4dict.p__Index._File-number = b_proc._File-number:
        assign as4dict.p__Index._I-Misc2[6] = newlib + "/" + newaname.                  
     end.                                                                       
   end.                                              
    
   assign b_proc._File-Name = newname                       
          b_proc._AS4-File = CAPS(input frame prcprops s_AS400_Proc_Name)
          b_proc._AS4-Library = CAPS(input frame prcprops s_AS400_Libr_Name)
          b_proc._For-Name = CAPS(input frame prcprops s_AS400_Libr_Name) + "/" + 
                             (input frame prcprops s_AS400_Proc_Name)      
          input frame prcprops b_proc._Desc    
          b_proc._Fil-Misc1[1] = b_proc._Fil-Misc1[1] + 1
          b_proc._Fil-res1[8] = 1.
      
      /* Verify that file is marked as being last updated in ADE */ 
   IF SUBSTRING(b_proc._Fil-misc2[5],1,1) <> "Y" THEN
     ASSIGN SUBSTRING(b_proc._Fil-misc2[5],1,1) = "Y".
      
   IF b_proc._Fil-res1[7] < 0 then assign b_proc._Fil-res1[7] = 0. 
      
   if oldname <> newname then do:
     /* If name was changed and the procedure is currently showing 
        change the name in the browse list.
        If there's more than one procedure, delete and re-insert to
        make sure the new name is in alphabetical order.
     */
 
    if s_lst_Proc:NUM-ITEMS in frame browse > 1 then do:
      s_Res = s_lst_Proc:delete(oldname) in frame browse.

      /* Put in non case-sensitive variable for next search. */
      ins_name = newname.  
      {as4dict/prc/nextproc.i &Name = ins_name
                              &Next = nxtname}
      run as4dict/_newobj.p
	     (INPUT s_lst_Proc:HANDLE in frame browse,
	      INPUT ins_name,
	      INPUT nxtname,
	      INPUT s_Proc_Cached,
	      INPUT {&OBJ_Proc}).
    end.
    else do:
       /* Change name in place in browse window list */
       {as4dict/repname.i
	   &OldName = oldname
	   &NewName = newname
	   &Curr    = s_CurrProc
	   &Fill    = s_ProcFill
   	   &List    = s_lst_Proc}
    end.
  end.

  {as4dict/setdirty.i &Dirty = "true"}.
  /* If we just made the last table hidden, the property sheet may be
      gone (from brwadj.p)!  So we'd better check before doing this.
   */
  if s_win_Proc <> ? then
      display "Procedure modified" @ s_Status with frame prcprops.     
      
  /* Must force release of record to DataServer but do not want to loose record so
        issue a validate with no-error.  */
  VALIDATE b_proc NO-ERROR. 
  run adecomm/_setcurs.p ("").
  return.     
end.

run adecomm/_setcurs.p ("").
return "error".



