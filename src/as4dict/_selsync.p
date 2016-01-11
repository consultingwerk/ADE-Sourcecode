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

/*
  Procedure _selsync.p
  Created 09/28/97
  D. McMann
  
  Procedure to run which will allow the user to select specific files to be
  synchronized to the client schema holder.

  Modified:  DLM 11/10/97 Placed buttons in correct position for TTY and
                          fixed 97-11-05-021
             DLM 06/03/98 Added DICTDB for finds 98-04-03-003
                            Added check for at least one file being chosen
                            98-03-11-016 
             DLM 07/08/98 Removed check on _db to see if in sync
                            98-07-03-003
             DLM 08/02/99 Added stored procedures and sequences to selective
                            sync 19980407-038               
                             
*/  

{ prodict/dictvar.i }
{ prodict/user/uservar.i } 
{ prodict/user/userhue.i }       
{ prodict/user/userhdr.f } 

DEFINE VARIABLE oxlname AS CHARACTER                NO-UNDO.  
DEFINE VARIABLE ctlbrk     AS LOGICAL INITIAL TRUE. 
DEFINE VARIABLE fldcnt   AS INTEGER                 NO-UNDO.
DEFINE VARIABLE dofield AS LOGICAL                  NO-UNDO. 
DEFINE VARIABLE insync    AS CHARACTER              NO-UNDO.
DEFINE VARIABLE answer  AS LOGICAL INITIAL FALSE    NO-UNDO. 
Define variable s_lst_Files as char    NO-UNDO. 
Define variable s_lst_FileChoice as character NO-UNDO.
Define button s_btn_FileAdd label "&Add >>"     SIZE 12 by 1.
Define button s_btn_FileRmv label "<< &Remove"  SIZE 12 by 1.
Define var all_cnt   as integer NO-UNDO.
Define var num_fls  as integer  INITIAL 0 NO-UNDO.
DEFINE VARIABLE fnum AS INTEGER NO-UNDO.
Define variable list-contents as character initial "" no-undo.
DEFINE VARIABLE dspname  AS CHARACTER               NO-UNDO.
DEFINE VARIABLE fls      AS CHARACTER               NO-UNDO.
DEFINE VARIABLE l-name     AS CHARACTER               NO-UNDO.
DEFINE BUTTON s_btn_Ok          LABEL "OK"    size 12 by 1 AUTO-GO.

/* defines for dumpname.i */
DEFINE VARIABLE nam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE pass AS INTEGER   NO-UNDO.

form
   SKIP(1)
 
    "Select Objects to process:"               at 2
                        view-as TEXT                               
   "Objects to be processed:"                     at 47 
                        view-as TEXT                               
   SKIP

   s_lst_FileChoice         NO-LABEL                  at 2
                        view-as SELECTION-LIST SINGLE 
                        INNER-CHARS 25 INNER-LINES 10
                        SCROLLBAR-V SCROLLBAR-H        
   
   s_lst_Files             NO-LABEL                   at 47 
                        view-as SELECTION-LIST SINGLE 
                        INNER-CHARS 28 INNER-LINES 10     
                        SCROLLBAR-V SCROLLBAR-H       
   s_btn_FileAdd                                             at col 33 row 5 SKIP
   s_btn_FileRmv                                             at     33 SKIP (1)
   "T = Table" at  33 view-as text
   "P = Procedure" at 33 view-as text
   "S = Sequence" AT 33 VIEW-AS TEXT
 &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SKIP(2)
 &ELSE SKIP(4)
 &ENDIF
   

   space (2) s_btn_Ok  btn_Cancel
  with frame syncfile
      SIDE-LABELS SCROLLABLE
      TITLE "Selective Synchronization" view-as DIALOG-BOX three-d.
      
          

FORM
  dspname    LABEL "Database" COLON 11 FORMAT "x(32)":u SKIP
  as4dict.p__File._File-name  LABEL "Table"    COLON 11 FORMAT "x(32)":u SKIP
  as4dict.p__Field._Field-name LABEL "Field"    COLON 11 FORMAT "x(32)":u SKIP
  as4dict.p__Index._Index-name LABEL "Index"    COLON 11 FORMAT "x(32)":u SKIP
  as4dict.p__Seq._Seq-Name   LABEL "Sequence" COLON 11 FORMAT "x(32)":u SKIP   
  HEADER 
    " Synchronizing Definitions. Press " +
    KBLABEL("STOP") + " to terminate process." format "x(70)" 
  WITH FRAME working 
  ROW 4 CENTERED OVERLAY USE-TEXT SIDE-LABELS THREE-D VIEW-AS DIALOG-BOX.


/*=========================Internal Procedures===============================*/

/*-----------------------------------------------------------------
   Remove the selected field name from one list and add it
   to the other.

   Input Parameters:
      p_lst_Add  - Handle of selection list to add the name to.
      p_lst_Rmv  - Handle of selection list to remove name from.
      p_To_List - True, if the file is being added to the list or
                                false if file is being removed from the list.
------------------------------------------------------------------*/
PROCEDURE Transfer_Name:

Define INPUT parameter p_lst_Add  as widget-handle NO-UNDO.
Define INPUT parameter p_lst_Rmv  as widget-handle NO-UNDO.
Define INPUT parameter p_To_List as logical       NO-UNDO.

Define var flname as char    NO-UNDO.
Define var cnt            as integer NO-UNDO.
Define var pos     as integer NO-UNDO.
Define var nxtname as char    NO-UNDO.
Define var ix      as integer NO-UNDO.  /* loop index */
define var s_Res as logical no-undo.

   /* Get the selected name from the "remove list". */
   flname = p_lst_Rmv:screen-value.

   /* Remove this name from the "remove list" */
   run adecomm/_delitem.p (INPUT p_lst_Rmv, INPUT flname, OUTPUT cnt).

   if p_To_List then
 
      s_Res = p_lst_Add:ADD-LAST(flname). 
  
   else do:
 
      /* Insert file back in it's proper place.  Determine the position
               this file took in original list.  Look from this point
               down in original list until we find an entry that is still in
               the left hand file list.  This is the entry we want to insert
               above.
      */
      pos = LOOKUP(flname, s_lst_FileChoice:private-data in frame syncfile).
      do ix = pos + 1 to all_cnt:
               nxtname = ENTRY(ix, s_lst_FileChoice:private-data in frame syncfile).
               if p_lst_Add:LOOKUP(nxtname) <> 0
                  then leave.
      end.      
      if ix > all_cnt then
               s_Res = p_lst_Add:ADD-LAST(flname). 
      else
               s_Res = p_lst_Add:INSERT(flname, nxtname).
   end. 

   /* Select the flname value, making sure it's in view. */
   p_lst_Add:screen-value = flname.
   run adecomm/_scroll.p (INPUT p_lst_Add, INPUT flname).
end.


/*-----------------------------------------------------------------
   Add the currently selected file to the list.
------------------------------------------------------------------*/
PROCEDURE Add_File:
   Define var val as char NO-UNDO.

   run Transfer_Name (INPUT s_lst_Files:HANDLE in frame syncfile,
                      INPUT s_lst_FileChoice:HANDLE in frame syncfile,
                      INPUT true).

   num_fls = num_fls + 1.

    assign
      s_lst_Files:sensitive in frame syncfile = yes
      s_btn_FileRmv:sensitive in frame syncfile = yes.
end.


/*--------------------------------------------------------------------
   Remove the currently selected file from the list.
---------------------------------------------------------------------*/
PROCEDURE Remove_File:
   run Transfer_Name (INPUT s_lst_FileChoice:HANDLE in frame syncfile,
                                   INPUT s_lst_Files:HANDLE in frame syncfile,
                                   INPUT false).

   num_fls = num_fls - 1.

   if num_fls = 0 then
      assign
               s_lst_Files:sensitive in frame syncfile = no
               s_btn_FileRmv:sensitive in frame syncfile = no   
      s_btn_FileAdd:sensitive in frame syncfile = yes.
end.


/*----- HIT of ADD >> (add file) BUTTON -----*/
on choose of s_btn_FileAdd in frame syncfile
   run Add_File.


/*----- DEFAULT-ACTION (DBL-CLICK or RETURN) of FIle CHOICE LIST -----*/
on default-action of s_lst_FileChoice in frame syncfile
   run Add_File.


/*----- HIT of REMOVE >> (remove file) BUTTON -----*/
on choose of s_btn_FileRmv in frame syncfile 
   run Remove_File.


/*----- DEFAULT-ACTION (DBL-CLICK or RETURN) of INDEX FILE LIST -----*/
on default-action of s_lst_Files in frame syncfile
   run Remove_Field.

on choose of btn_cancel in frame syncfile
  return "insync".

on choose of s_btn_OK in frame syncfile do:
  IF num_fls = 0 THEN DO:
    MESSAGE "You must select at least one file to synchronize." SKIP
        VIEW-AS ALERT-BOX WARNING BUTTON OK.
    RETURN NO-APPLY.
  END.
END.  

/*============================Mainline code==================================*/

SESSION:IMMEDIATE-DISPLAY = TRUE.
   
FIND DICTDB._db where DICTDB._db._db-name = LDBNAME("as4dict").     

IF DICTDB._Db._db-addr = ? OR DICTDB._Db._Db-addr = "" THEN
  ASSIGN dspname = DICTDB._Db._Db-name.
ELSE
  ASSIGN dspname = DICTDB._Db._Db-addr.
        
IF user_env[1] = "" THEN DO:
  FIND FIRST DICTDB._File of DICTDB._Db WHERE  NOT DICTDB._File._Hidden  NO-LOCK NO-ERROR.
   IF NOT AVAILABLE DICTDB._File THEN ASSIGN user_env[1] = "add".
 END.   

FIND FIRST as4dict.p__file NO-LOCK NO-ERROR.
IF NOT AVAILABLE as4dict.p__file THEN DO:       
   MESSAGE dspname "does not have any schema defined." SKIP
            "Synchronization can not be performed." SKIP
            VIEW-AS ALERT-BOX INFORMATION BUTTON OK.            
   RETURN "noschema".
END.                  

FIND as4dict.p__db NO-LOCK.

FOR EACH as4dict.p__file NO-LOCK by as4dict.p__File._File-name :
 if list-contents = "" THEN DO:
   IF as4dict.p__File._For-Info = "PROCEDURE" THEN
     ASSIGN list-contents = "P " + STRING(as4dict.p__File._File-name, "x(20)").
   ELSE
     ASSIGN list-contents = "T " + STRING(as4dict.p__File._File-name, "x(20)").
 END.     
 else DO:
   IF as4dict.p__File._For-Info = "PROCEDURE" THEN
     assign list-contents = list-contents + ",P " + STRING(as4dict.p__File._File-name,"x(20)").
    ELSE
      assign list-contents = list-contents + ",T " + STRING(as4dict.p__File._File-name,"x(20)").
  END.
END. 
FOR EACH as4dict.p__Seq NO-LOCK BY as4dict.p__Seq._Seq-name:
  if list-contents = "" THEN    
     ASSIGN list-contents = "S " + STRING(as4dict.p__Seq._Seq-name, "x(20)").
   ELSE     
     ASSIGN list-contents = list-contents + ",S " + STRING(as4dict.p__Seq._Seq-name,"x(20)").
END.
enable s_lst_FileChoice
      with frame syncfile.
        
s_lst_FileChoice:LIST-ITEMS in frame syncfile = "".
s_lst_FileChoice:private-data in frame syncfile = "".

assign 
  s_lst_FileChoice:LIST-ITEMS in frame syncfile = list-contents
  s_lst_FileChoice:private-data in frame syncfile = s_lst_FileChoice:LIST-ITEMS in frame syncfile
  all_cnt = NUM-ENTRIES(s_lst_FileChoice:private-data in frame syncfile)
  s_lst_Files:LIST-ITEMS in frame syncfile = "" /* clear the list */
   
      /* Reset sensitiveness of widgets */
  s_lst_Files:sensitive in frame syncfile = false. 
  s_btn_FileAdd:sensitive in frame syncfile = yes.
 

display s_lst_FileChoice
        s_lst_Files   
   with frame syncfile.
       
s_lst_FileChoice:screen-value in frame syncfile = s_lst_FileChoice:entry(1) in frame syncfile.
    
enable
   s_btn_Ok  btn_Cancel
   with frame syncfile.
           
wait-for choose of s_btn_OK in frame syncfile or 
      close of frame syncfile
      FOCUS s_lst_FileChoice in frame syncfile.

fls = s_lst_Files:LIST-ITEMS in frame syncfile. /* Get all files in list */

_uploop:
DO ON ERROR UNDO,LEAVE _uploop ON ENDKEY UNDO,LEAVE _uploop 
       ON STOP UNDO, LEAVE _uploop:          
  run adecomm/_setcurs.p ("WAIT").
  IF user_env[34] <> "batch" THEN  COLOR DISPLAY MESSAGES
     dspname as4dict.p__File._File-name as4dict.p__Field._Field-name
     as4dict.p__Index._Index-name as4dict.p__Seq._Seq-Name 
    WITH FRAME working.
  IF user_env[34] <> "batch" THEN  DISPLAY dspname with frame working.          
  IF _db._Db-xl-name <> as4dict.p__db._Db-xl-name THEN 
    ASSIGN user_env[35] = _Db._Db-name.
     
  ASSIGN _Db._Db-misc1[1] = as4dict.P__db._Db-misc1[1]
         _Db._Db-misc1[2] = as4dict.P__db._Db-misc1[2] 
         _Db._Db-misc1[3] = as4dict.p__Db._Db-misc1[3] 
         _Db._Db-misc1[4] = as4dict.p__Db._Db-misc1[4]  
         _Db._Db-misc2[1] = as4dict.P__db._Db-misc2[1]
         _Db._Db-misc2[3] = SUBSTRING(as4dict.p__Db._Db-misc2[3],1,1)
         oxlname          = _Db._Db-xl-name
         _Db._Db-xl-name  = as4dict.P__Db._Db-xl-name.
               
         
    /*------------------------ _File processing ------------------------------*/
    /* File Loop for each table selected, it's fields, 
    File Triggers, and Indices will be processed within. p__file */
  
  _fileloop:
  DO fnum = 1 to num_fls:
    assign l-name = SUBSTR(ENTRY(fnum, fls), 1, 32).
    IF l-name = "" OR l-name = ? THEN NEXT _fileloop.
    IF NOT l-name BEGINS "S" THEN DO: /* Either a file or procedure */
      ASSIGN l-name = substring(l-name,3).
      
      FIND as4dict.p__File WHERE as4dict.p__File._File-name = l-name NO-LOCK.                                                            
       /* This include is used in both the full sync and selective sync. */
      { as4dict/as4sync.i }
    END.
    ELSE DO: /* Sync a Sequence */
      ASSIGN l-name = substring(l-name,3).
      FIND as4dict.p__Seq WHERE as4dict.p__Seq._Seq-name = l-name NO-LOCK.
      FIND _Sequence WHERE _Sequence._Seq-name = as4dict.p__Seq._Seq-name NO-ERROR.
      IF AVAILABLE (_Sequence) THEN DO:                    
        IF user_env[34] <> "batch" THEN  Display as4dict.p__Seq._Seq-name 
        with frame working.  /* MODIFY Sequence */
        {as4dict/as4synsq.i}
      END.
      ELSE DO:                                      /* ADD Sequence */
        display as4dict.p__Seq._Seq-name with frame working.  
        CREATE _Sequence.  
        ASSIGN _Sequence._Seq-name = as4dict.p__Seq._Seq-name
               _Sequence._DB-recid = RECID(_DB).
        {as4dict/as4synsq.i}
      END. 
    END.
  END.        /* end _fileloop  */           
end.








