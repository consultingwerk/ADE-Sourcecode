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

File: _newproc.p

Description:
   Display and handle the add procedure dialog box and then add the procedure
   if the user presses OK.

Author: Donna McMann

Date Created: 04/01/99
     History: D. McMann Added help for Stored Procedures Support 07/20/99
              D. McMann Added CHKOBJ for program and changed window 12/20/99

----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{adecomm/cbvar.i shared}
{as4dict/capab.i}
{as4dict/prc/procvar.i shared}

Define var capab as char    NO-UNDO.
Define var added as logical NO-UNDO INIT no.
Define var numerr as logical NO-UNDO. 
Define var i as integer NO-UNDO.   

/*===============================Triggers====================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame newproc       
   apply "END-ERROR" to frame newproc.


/*----- HIT of OK BUTTON -----*/
on choose of s_btn_OK in frame newproc
   s_OK_Hit = yes.
   /* The GO trigger will fire after this. */

/*----- HIT of DONE BUTTON ------- */
on choose of s_btn_done in frame newproc
do:  
  IF dba_unres THEN DO:             
    dba_cmd = "UNRESERVE".
    RUN  as4dict/_dbaocmd.p 
	 (INPUT " ", 
	  INPUT CAPS(input frame newproc s_AS400_Proc_name),
      	  INPUT CAPS(input frame newproc s_AS400_Libr_name),
	  INPUT 0,
	  INPUT 0).     
	  
    IF dba_return <> 1 THEN
      MESSAGE "Problem with unreserve " + string(dba_return)
       view-as alert-box information button ok.	  
  END.
  hide frame newproc.
  CLEAR FRAME newproc.
  return.    
end.
	       
/*----- HIT of OK BUTTON or ADD BUTTON or GO -----*/
on GO of frame newproc	/* or buttons - because they're auto-go */
do:
   DEFINE VARIABLE no_name  AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE nxtname  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE okay     AS LOGICAL   NO-UNDO.

   run as4dict/_blnknam.p
      (INPUT b_Proc._File-name:HANDLE in frame newproc,
       INPUT "procedure", OUTPUT no_name).
   if no_name then do:
      s_OK_Hit = no.  /* in case ok was hit */
       return NO-APPLY.
   end.           
   run as4dict/_blnknam.p
      (INPUT s_AS400_Proc_name:HANDLE in frame newproc,
       INPUT "program", OUTPUT no_name).
   if no_name then do:
      s_OK_Hit = no.  /* in case ok was hit */
       return NO-APPLY.
   end.           
   
   RUN as4dict/_chkobj.p
     (INPUT INPUT FRAME newproc s_AS400_Proc_name,
      INPUT INPUT FRAME newproc s_AS400_Libr_name,
      INPUT s_win_Proc,
      INPUT "*PGM", 
      OUTPUT okay). 

   IF NOT okay THEN DO:
      ASSIGN s_OK_Hit = no.  /* in case ok was hit */
      RETURN NO-APPLY.
   END.    

  
  IF NOT  dba_unres THEN DO:     
    define var lname as character.
     
    run as4dict/_libnam.p (INPUT s_AS400_Libr_name, INPUT s_win_Proc,  
                           INPUT input frame newproc s_AS400_Proc_name,
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
      
      assign
         input frame newproc b_Proc._File-name 
         b_Proc._As4-File = CAPS(input frame newproc s_AS400_Proc_name)
         b_Proc._AS4-Library = CAPS(input frame newproc s_AS400_Libr_name )
         b_Proc._For-name = CAPS(input frame newproc s_AS400_Libr_name) + "/" +
                           CAPS(input frame newproc s_AS400_Proc_name) 	 
	 input frame newproc b_Proc._Desc                          
	 b_Proc._For-number = b_Proc._File-number
	 b_Proc._Prime-index = -1
	 b_Proc._Hidden = "N"	
	 b_Proc._Frozen = "N" 
	 b_Proc._Can-Create = "*"
	 b_Proc._Can-Delete = "*"
	 b_Proc._Can-Dump = "*"
	 b_Proc._Can-Load = "*"
	 b_Proc._Can-Read = "*"
	 b_Proc._Can-Write = "*"
	 b_Proc._Db-recid = 1
	 b_Proc._For-Info = "PROCEDURE".
    
     IF LENGTH(b_Proc._As4-File) > 8 THEN
       ASSIGN b_Proc._Dump-Name = lc(SUBSTRING(b_Proc._As4-File,1,8)).
     ELSE
       ASSIGN b_Proc._Dump-name = lc(b_Proc._As4-file).
         
     IF CAN-FIND (FIRST as4dict.p__file WHERE as4dict.p__File._Dump-name =
                  b_Proc._Dump-name) THEN
     _dloop:             
     DO i = 1 TO 9999999:
       ASSIGN b_Proc._Dump-name = lc(SUBSTRING(b_Proc._As4-File,1,(8 - LENGTH(string(i)))) + STRING(i)).
       IF NOT CAN-FIND (FIRST as4dict.p__file WHERE as4dict.p__File._Dump-name =
                  b_Proc._Dump-name) THEN
         LEAVE _dloop.
     END.   

/* _Fil-misc2[4] is a list of flags for the AS400.  The bits mean: 
       1 - triggers, 2 constraints, 3 - null indicator, 4-7 can read, write
       update, delete, 8 - read only
       
    _Fil-misc2[4] bit 3 may be changed when fields are added if any allow
    nulls but will initially be set to N    */
       
    ASSIGN b_Proc._Fil-Misc2[4] = "NNNYYYNN".
                                    	 
/* The origin of the file is the client, store this information in
  Fil-Misc2[5]  */  
   Assign b_Proc._Fil-Misc2[5] = "Y".        
   
 /* Set the index indicator to -1 until primary index is set */
 
   Assign b_Proc._Fil-misc1[7] = -1.    
              
/*  Make sure the current table number is re-set   */
   Assign s_ProcForNo = b_Proc._For-number.
      
 /* Add entry to procedures list in alphabetical order */
      
   {as4dict/prc/nextproc.i &Name = b_Proc._File-Name  
      	       	     	      	&Next = nxtname}
    run as4dict/_newobj.p
	    (INPUT s_lst_Proc:HANDLE in frame browse,
	     INPUT b_Proc._File-name,
	     INPUT nxtname,
	     INPUT s_Proc_Cached,
	     INPUT {&OBJ_Proc}).
    

      {as4dict/setdirty.i &Dirty = "true"}.
      display "Procedure Created" @ s_Status with frame newproc.
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
on LEAVE of s_btn_Add in frame newproc
   display "" @ s_Status with frame newproc. /* clear status line */


/*----- HELP -----*/
on HELP of frame newproc OR choose of s_btn_Help in frame newproc
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", {&AS4_Create_Procedure_Dlg_Box}, ?).

/*============================Mainline code==================================*/
/* Get the as4dict.p__Db record so it can be used to find where the objects
   should be placed. */
find first as4dict.p__db NO-LOCK.   

/* Since this is a shared frame we have to avoid doing this code more
   than once.
*/
if frame newproc:private-data <> "alive" then
do:
   frame newproc:private-data = "alive".

   /* Run time layout for button area.  This defines eff_frame_width */
   {adecomm/okrun.i  
      &FRAME = "frame newproc" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }
   
   /* So Return doesn't hit default button in editor widget. */
   b_Proc._Desc:RETURN-INSERT in frame newproc = yes.
   
   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_optional:width-chars in frame newproc = eff_frame_width - ({&HFM_WID} * 2).
end.

/* Erase any status from the last time */
s_Status = "".
display s_Status with frame newproc.
s_btn_Done:label in frame newproc = "Cancel".   


/* Default the value of the p__Db.OBJECTLIB */
s_AS400_Libr_name = caps(as4dict.p__DB.OBJECTLIB).

/* Each add will be a subtransaction */
s_OK_Hit = no.    

add_subtran:
repeat ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   /* Do this up top here, to be sure we committed the last create */
   if s_OK_Hit then leave add_subtran.

   if added AND s_btn_Done:label in frame newproc <> "Close" then
      s_btn_Done:label in frame newproc = "Close".
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
              "library is either missing or is locked.  A new procedure can"
              "not be generated."
         VIEW-AS ALERT-BOX ERROR BUTTON OK.     
         assign numerr = true.          
         enable s_btn_done with frame newproc.         
        APPLY "CHOOSE" to s_btn_Done in frame newproc.       
    END.                  

   create b_Proc.                   
   assign b_Proc._File-number =  dba_return .        
   
/* moved enable statement to behind the create statement to avoid */
/* problems with buffer b_Proc <hutegger, 94/02/03> */
/* Note: the order of enables will govern the TAB order. */

   enable 
       b_Proc._File-Name
       s_AS400_Proc_name
       s_AS400_Libr_name
       b_Proc._Desc                  
       s_btn_OK
       s_btn_Add
       s_btn_Done
       s_btn_Help
       with frame newproc.

/* Have to display all fields, so on 2nd or 3rd add, any entered values
      will be cleared. */
   display "" @ b_Proc._File-Name   /* display blank instead of ? */
           "" @ s_AS400_Proc_name   
          s_AS400_Libr_name
      	   s_optional      	   
      	   b_Proc._Desc
      	   with frame newproc.

   wait-for choose of s_btn_OK, s_btn_Add in frame newproc OR
      	    GO of frame newproc
      	    FOCUS b_Proc._File-Name in frame newproc.
end.                                        

hide frame newproc.
  
if s_OK_Hit  then /* but not Create */
  apply "choose" to MENU-ITEM mi_Crt_Parm in MENU s_mnu_Create.  
 

return.




