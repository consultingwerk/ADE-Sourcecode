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

File: edittrig.i

Description:
   Here we have all the trigger definitions for the edit (properties)
   windows.
 
Author: Laura Stern

Date Created: 02/04/92 
 Modified for Progress/AS400 Data Dictionary by Nancy Horn and Donna McMann
    12/28/94
 Modified to remove error message on unreserve 09/30/96 D. McMann 
 05/19/98 D. McMann Added triggers for changing field properties when file\
                    has not been committed.  
 07/20/99 D. McMann Added help for Stored Procedures Support 
 09/09/99 D. McMann b_file changed to b_proc.
 12/22/99 D. McMann Added CHKOBJ for program
 08/16/00 D. McMann Added Raw Data Type Support
 10/30/00 D. McMann Added check when copying fields.
    
----------------------------------------------------------------------------*/

/*======================Triggers for Browse Window===========================*/


/*----- HELP anywhere -----*/
on HELP anywhere
   RUN "adecomm/_adehelp.p" ("as4d", "TOPICS", {&AS4_Data_Dictionary_Window}, ?).


/*====================Triggers for Database Properties=======================*/

/*----- END-ERROR or OK BUTTON in DBPROPS FRAME -----*/
on END-ERROR of frame dbprops OR choose of s_btn_OK in frame dbprops
do:
   {as4dict/delwin.i &Win = s_win_Db &Obj = {&OBJ_DB}}
   return NO-APPLY.  /* don't really do end-key processing */
end.

/*----- HELP in DBPROPS FRAME -----*/
on HELP of frame dbprops OR choose of s_btn_Help in frame dbprops
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", 
                                               {&AS4_Database_Properties_Window}, ?).


/*======================Triggers for Table Properties=======================*/

/*----- END-ERROR OR CLOSE BUTTON of TBLPROPS FRAME -----*/
on END-ERROR of frame tblprops OR choose of s_btn_Close in frame tblprops
do:      
   IF dba_unres THEN DO:
        dba_cmd = "UNRESERVE".
        RUN  as4dict/_dbaocmd.p 
         (INPUT "PF", 
          INPUT input frame tblprops s_AS400_File_Name,
                INPUT input frame tblprops s_AS400_Lib_Name,
          INPUT 0,
          INPUT 0).   
            
    end.                   
   {as4dict/delwin.i &Win = s_win_Tbl &Obj = {&OBJ_TBL}}
   return NO-APPLY.  /* otherwise it will undo everything! */
end.

/*----- HIT of SAVE BUTTON -----*/
on choose of s_btn_Save in frame tblprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   run as4dict/TBL/_savetbl.p.
   IF (RETURN-VALUE <> "error" AND
       s_btn_Close:label in frame tblprops <> "Close") then
      s_btn_Close:label in frame tblprops = "Close".
end.

/*----- HIT of OK BUTTON or GO -----*/
on GO of frame tblprops
do:                           
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.
  
  if input frame tblprops s_AS400_File_name <> b_File._AS4-File then        
     apply "leave" to s_AS400_File_name in frame tblprops. 

 IF NOT  reserved THEN DO:     
    define var lname as character.
    define var okay as logical.
     
    run as4dict/_libnam.p (INPUT input frame tblprops s_AS400_Lib_Name, INPUT s_win_Tbl,  
                                               INPUT input frame tblprops s_AS400_File_name,
                                             OUTPUT lname, OUTPUT okay).       
                                       
   if not okay  then do:
        assign s_Valid = no
               s_OK_Hit = no.
        return NO-APPLY.              
    end.
  end.

   run as4dict/TBL/_savetbl.p.
   if RETURN-VALUE = "error" then
      return NO-APPLY.

   {as4dict/delwin.i &Win = s_win_Tbl &Obj = {&OBJ_TBL}}
end.


/*----- HIT of NEXT button -----*/
on choose of s_btn_Next in frame tblprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.
   run as4dict/_nextobj.p ({&OBJ_TBL}, true).
end.


/*----- HIT of PREV button -----*/
on choose of s_btn_Prev in frame tblprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   run as4dict/_nextobj.p ({&OBJ_TBL}, false).
end.


/*----- LEAVE of SAVE BUTTON -----*/
on leave of s_btn_Save in frame tblprops
   /* Since status is displayed only after save is hit */
   display "" @ s_Status with frame tblprops. /* clear status line */


/*----- HELP in TBLPROPS FRAME -----*/
on HELP of frame tblprops OR choose of s_btn_Help in frame tblprops 
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", {&AS4_Table_Properties_Window}, ?).


/*----- LEAVE of NAME FIELD -----*/
on leave of b_File._File-Name in frame newtbl,
            b_File._File-Name in frame tblprops
do:
   Define var okay  as logical NO-UNDO.
   Define var name  as char    NO-UNDO.
   Define var dname as char    NO-UNDO.
   Define var aname as char    NO-UNDO.

   if s_Adding then
      display "" @ s_Status with frame newtbl.  /* clear status after add */
   
    run as4dict/_leavnam.p (INPUT b_File._File-name,
                           INPUT s_win_Tbl, 
                           INPUT b_File._File-number,
                           INPUT {&OBJ_TBL},
                           OUTPUT name, 
                           OUTPUT okay).             
             
                                         
   if okay = ? then return.
   if NOT okay then do:
      s_OK_Hit = no.
      s_Valid = no.
      return NO-APPLY.
   end.

   /* Name is ok.  For Add, get AS/400 name and default the dump-name if it has no value yet. */
   if s_Adding then 
   do:                                  
      aname = input frame newtbl s_AS400_File_Name.
      if aname = "" OR aname = ? then 
      do:      
       s_AS400_File_Name:screen-value in frame newtbl = CAPS(name).
         apply "leave" to s_AS400_File_name in frame newtbl. 
      end.    
        
      dname = input frame newtbl b_File._Dump-name.
      if dname = "" OR dname = ? then
      do:
         b_File._Dump-name:screen-value in frame newtbl = LC(name). /* lower case */
         apply "leave" to b_File._Dump-name in frame newtbl.
      end.
   end.
end.

/*----- LEAVE of AS400 File Name NAME -----*/
on leave of s_AS400_File_Name in frame newtbl,
                  s_AS400_File_Name in frame tblprops
do:
   Define var aname as char NO-UNDO.
   Define var name  as char NO-UNDO.
   Define var okay  as logical NO-UNDO.
 
   aname = TRIM(SELF:screen-value).

   /* If we're editing and name hasn't changed, then it's OK */
   if NOT s_Adding AND aname = s_AS400_File_name then
      return. 
  
   if aname <> s_AS400_File_name then
        assign reserved = false.
  
  if s_Adding then  
      display "" @ s_Status with frame newtbl.  /* clear status after add */

 IF s_Adding THEN  do:
      run as4dict/_lva4nam.p (INPUT  aname, INPUT s_win_Tbl,
                                             OUTPUT name, OUTPUT okay).                                                  
      IF LENGTH(name) > 0  THEN DO:                                                
          IF LENGTH(name) < 10  THEN
             b_File._For-Format:screen-value in frame newtbl = CAPS(name) + "R".
        ELSE
            b_File._For-Format:screen-value in frame newtbl = 
                                SUBSTRING(CAPS(name),1,9) + "R".     
       END.
       s_AS400_File_Name:screen-value in frame newtbl = CAPS(NAME).
  END.
  ELSE DO:
      run as4dict/_lva4nam.p (INPUT  b_File._AS4-File, INPUT s_win_Tbl,
                                             OUTPUT name, OUTPUT okay).    
      s_AS400_File_Name:screen-value in frame tblprops = CAPS(NAME).                                                                                          END.                        
                                  
  if okay = ? then return.                                                                            

  if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.                                       
 
   If s_Adding then                     
      apply "leave" to b_file._For-format in frame newtbl.              
   else
      apply "leave" to b_file._For-format in frame tblprops.        

end.
      
/*------LEAVE OF AS4-LIBRARY-NAME ----*/
on leave of s_AS400_Lib_Name in frame newtbl,
                       s_AS400_Lib_Name in frame tblprops
do:
  Define var lname as char NO-UNDO.
  Define var lib         as char NO-UNDO.   
  Define var okay    as logical NO-UNDO.     

   lname = TRIM(SELF:screen-value).                  
        
   if (lname = "?" OR lname = "") then
   do:
      message "Library name is required" 
      VIEW-AS ALERT-BOX Error BUTTON OK.
    
      s_Valid = no.
      return NO-APPLY.
   END.          
   lname = CAPS(lname).                                         
   if s_Adding then  do:    
   /* if we're editing and name hasn't changed then it's OK */

        display "" @ s_Status with frame newtbl.  /* clear status after add */   
   
        run as4dict/_libnam.p (INPUT lname, INPUT s_win_Tbl,  
                                               INPUT input frame newtbl s_AS400_File_name,   
                                            OUTPUT lname, OUTPUT okay).                                                  
        if okay then  
            dba_unres = true.              

        else do:
           s_Valid = no.    
               s_OK_Hit = no.                        
               return NO-APPLY.             
         end.            
    end.                                                                    
    else do:                
        /* if we're editing and name hasn't changed then it's OK */
        if  lname = b_File._AS4-Library 
            AND CAPS(b_file._AS4-File) = CAPS(input frame tblprops s_AS400_File_name) then
            return.        
            
        display "" @ s_Status with frame tblprops.  /* clear status after add */                   
       
        run as4dict/_libnam.p (INPUT lname, INPUT s_win_Tbl,  
                                               INPUT input frame tblprops s_AS400_File_name,
                                             OUTPUT lname, OUTPUT okay).       
        if okay then 
            dba_unres = true.                                                                                                
        else do:
           s_Valid = no.    
               s_OK_Hit = no.                        
               return NO-APPLY.             
         end.            
    end.                                                                   
end.
    

/*----- LEAVE of DUMP NAME -----*/
on leave of b_File._Dump-name in frame newtbl,
                  b_File._Dump-name in frame tblprops
do:
   Define var dname as char NO-UNDO.
   Define var name  as char NO-UNDO.

   dname = TRIM(SELF:screen-value).

   /* If we're editing and name hasn't changed, then it's OK */
   if NOT s_Adding AND dname = b_File._Dump-name then
      return.

   if (dname = "?" OR dname = "") then
   do:
      /* Default to the name of the file, lower-cased if there is one. */
      if s_Adding then
               name = LC(input frame newtbl b_File._File-Name).
      else
               name = LC(input frame tblprops b_File._File-Name).

      if name = "" OR name = ? then return.
      
      SELF:screen-value = name.
      dname = name.
   end.

   /* Make sure the name is unique. */
   find first as4dict.p__File
      where as4dict.p__File._Dump-name = dname 
          AND as4dict.p__File._File-number <> b_File._File-number
      NO-ERROR.                       
 
   if AVAILABLE as4dict.p__File then
   do:
      if NOT s_Adding then current-window = s_win_Tbl.
      message "This dump name is not unique within this database." 
               view-as ALERT-BOX ERROR
               buttons OK.
      s_Valid = no.
      return NO-APPLY.
   end.       
end.                                                        

/*----- LEAVE of  b_File._For-format -----*/
on leave of b_File._For-format in frame newtbl,
                   b_File._For-format in frame tblprops
do:
   Define var aname as char NO-UNDO.
   Define var name  as char NO-UNDO.
   Define var okay  as logical NO-UNDO.
   
   aname = TRIM(SELF:screen-value).

   /* If we're editing and name hasn't changed, then it's OK */
   if NOT s_Adding AND aname = b_File._For-format then
      return.

  if s_Adding then  DO:
      display "" @ s_Status with frame newtbl.  /* clear status after add */
         ASSIGN user_env[35] = "format".                               
        run as4dict/_lva4nam.p (INPUT  aname, INPUT s_win_Tbl,
                                             OUTPUT name, OUTPUT okay).  
        ASSIGN user_env[35] = "".                                           
  END.
  ELSE  do:
       ASSIGN user_env[35] = "format".       
        run as4dict/_lva4nam.p (INPUT  b_File._For-format, INPUT s_win_Tbl,
                                         OUTPUT name, OUTPUT okay).    
        ASSIGN user_env[35] = "".                                                                                         
    END.
  if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.                            

end.      

/*----- HIT of VALIDATION BUTTON -----*/
on choose of s_btn_Tbl_Validation in frame newtbl,
                   s_btn_Tbl_Validation in frame tblprops
do:

   Define var widg    as widget-handle NO-UNDO.
   Define var no_name as logical       NO-UNDO.

  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_File._File-name:HANDLE in frame newtbl.
   else do:
      widg = b_File._File-name:HANDLE in frame tblprops.
      current-window = s_win_Tbl.
   end.

   run as4dict/_blnknam.p
      (INPUT widg, INPUT "table", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run as4dict/TBL/_tblval.p.
   IF (NOT s_Adding AND RETURN-VALUE = "mod" AND
       s_btn_Close:label in frame tblprops <> "Close") then
      s_btn_Close:label in frame tblprops = "Close".
end.


/*----- HIT of TRIGGERS BUTTON -----*/
on choose of s_btn_Tbl_Triggers in frame newtbl,
                   s_btn_Tbl_Triggers in frame tblprops
do:
   Define var widg    as widget-handle NO-UNDO.
   Define var no_name as logical       NO-UNDO.
   Define var junk    as logical       NO-UNDO.

   run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_File._File-name:HANDLE in frame newtbl.
   else do:
      widg = b_File._File-name:HANDLE in frame tblprops.
      current-window = s_win_Tbl.
   end.

   /* Check if name is blank and return if it is */
   run as4dict/_blnknam.p
      (INPUT widg, INPUT "table", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run as4dict/TRIG/_trigdlg.p (INPUT {&OBJ_TBL}, 
                               INPUT "CREATE,DELETE,FIND,WRITE",
                                                 INPUT widg,
                                                 INPUT {&AS4_Table_Triggers_Dlg_Box}).
   IF (NOT s_Adding AND RETURN-VALUE = "mod" AND
       s_btn_Close:label in frame tblprops <> "Close") then
      s_btn_Close:label in frame tblprops = "Close".
end.


/*----- HIT of STRING ATTRIBUTES BUTTON -----*/
on choose of s_btn_Tbl_StringAttrs in frame newtbl,
                   s_btn_Tbl_StringAttrs in frame tblprops
do:
   Define var widg    as widget-handle NO-UNDO.
   Define var no_name as logical       NO-UNDO.

  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_File._File-name:HANDLE in frame newtbl.
   else do:
      widg = b_File._File-name:HANDLE in frame tblprops.
      current-window = s_win_Tbl.
   end.

   run as4dict/_blnknam.p
      (INPUT widg, INPUT "table", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run as4dict/TBL/_tblsas.p.
   IF (NOT s_Adding AND RETURN-VALUE = "mod" AND
       s_btn_Close:label in frame tblprops <> "Close") then
      s_btn_Close:label in frame tblprops = "Close".
end.


/*==================Triggers for Field Properties======================*/

/*----- END-ERROR OR CLOSE BUTTON of FLDPROPS FRAME -----*/
on END-ERROR of frame fldprops OR choose of s_btn_Close in frame fldprops
do:
   {as4dict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
   return NO-APPLY.  /* otherwise it will undo everything! */
end.

/*----- HIT of SAVE BUTTON -----*/
on choose of s_btn_Save in frame fldprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

  find as4dict.p__File where as4dict.p__File._File-number = s_TblForNo no-lock. 
  IF as4dict.p__File._Fil-Misc1[4] = 0  THEN
     run as4dict/FLD/_svupfld.p.
  ELSE     
     run as4dict/FLD/_savefld.p.
     
   IF (RETURN-VALUE <> "error" AND
      s_btn_Close:label in frame fldprops <> "Close") then
      s_btn_Close:label in frame fldprops = "Close".
end.


/*----- HIT of OK BUTTON or GO -----*/
on GO of frame fldprops
do: 

  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.
           
  find as4dict.p__File where as4dict.p__File._File-number = s_TblForNo no-lock. 
  IF as4dict.p__File._Fil-Misc1[4] = 0  THEN
     run as4dict/FLD/_svupfld.p.
  ELSE  
     run as4dict/FLD/_savefld.p.
   
   if RETURN-VALUE = "error" then
      return NO-APPLY.

   {as4dict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
end.


/*----- HIT of NEXT button -----*/
on choose of s_btn_Next in frame fldprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.
   run as4dict/_nextobj.p ({&OBJ_FLD}, true).
end.


/*----- HIT of PREV button -----*/
on choose of s_btn_Prev in frame fldprops
do:
   run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.
   run as4dict/_nextobj.p ({&OBJ_FLD}, false).
end.


/*----- LEAVE of FIELD SAVE BUTTON -----*/
on leave of s_btn_Save in frame fldprops
   display "" @ s_Status with frame fldprops. /* clear status line */


/*----- HELP in FLDPROPS FRAME -----*/
on HELP of frame fldprops OR choose of s_btn_Help in frame fldprops 
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", {&AS4_Field_Properties_Window}, ?).


/*----- HIT of VALIDATION BUTTON (newfld/fldprops)-----*/
on choose of s_btn_Fld_Validation in frame newfld,
                   s_btn_Fld_Validation in frame fldprops
do:
   Define var widg     as widget-handle NO-UNDO.
   Define var no_name  as logical       NO-UNDO.
   Define var readonly as logical       NO-UNDO.

  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_Field._Field-name:HANDLE in frame newfld.
   else do:
      widg = b_Field._Field-name:HANDLE in frame fldprops.
      current-window = s_win_Fld.
   end.

   run as4dict/_blnknam.p
      (INPUT widg, INPUT "field", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run as4dict/FLD/_fldval.p (INPUT s_Fld_ReadOnly).
   IF (NOT s_Adding AND RETURN-VALUE = "mod" AND
       s_btn_Close:label in frame fldprops <> "Close") then
      s_btn_Close:label in frame fldprops = "Close".
end.


/*----- HIT of TRIGGERS BUTTON (newfld/fldprops) -----*/
on choose of s_btn_Fld_Triggers in frame newfld,
                   s_btn_Fld_Triggers in frame fldprops
do:
   Define var widg    as widget-handle NO-UNDO.
   Define var no_name as logical       NO-UNDO.
   Define var junk    as logical       NO-UNDO.

  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_Field._Field-name:HANDLE in frame newfld.
   else do:
      widg = b_Field._Field-name:HANDLE in frame fldprops.
      current-window = s_win_Fld.
   end.

   run as4dict/_blnknam.p
      (INPUT widg, INPUT "field", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run as4dict/TRIG/_trigdlg.p (INPUT {&OBJ_FLD}, 
                               INPUT "ASSIGN",
                                                 INPUT widg,
                                                 INPUT {&AS4_Field_Triggers_Dlg_Box}).
   IF (NOT s_Adding AND RETURN-VALUE = "mod" AND
       s_btn_Close:label in frame fldprops <> "Close") then
      s_btn_Close:label in frame fldprops = "Close".
end.


/*----- HIT of VIEW-AS BUTTON (fldprops)-----*/
on choose of s_btn_Fld_ViewAs in frame fldprops
do:
   Define var mod  as logical NO-UNDO.
   Define var temp as char    NO-UNDO.

   /* trigger for new field is in _newfld.p because dtype
      source is different */

   Define var no_name as logical NO-UNDO.

  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   current-window = s_win_Fld.      

   run as4dict/_blnknam.p
      (INPUT b_Field._Field-name:HANDLE in frame fldprops, 
       INPUT "field", OUTPUT no_name).
   if no_name then return NO-APPLY.

   /* Can't update field directly as in-out parm because if read-only
      this causes an error.
   */                               
  
     temp = b_Field._View-as.
     run as4dict/_viewas.p
        (INPUT s_Fld_ReadOnly, INPUT b_Field._Dtype, INPUT s_Fld_ProType,
         INPUT-OUTPUT temp, OUTPUT mod). 

     if mod then do:   
        b_Field._View-as = temp.    
        find as4dict.p__File where as4dict.p__File._File-number = s_TblForNo.         
        as4dict.p__File._Fil-Res1[8] = 1.
        {as4dict/setdirty.i &Dirty = "true"}.
        if (s_btn_Close:label in frame fldprops <> "Close") then
                 s_btn_Close:label in frame fldprops = "Close".
     end.
end.

/*----- HIT of STRING ATTRIBUTES BUTTON (newfld/fldprops)-----*/
on choose of s_btn_Fld_StringAttrs in frame newfld,
                   s_btn_Fld_StringAttrs in frame fldprops
do:
   Define var widg     as widget-handle NO-UNDO.
   Define var no_name  as logical       NO-UNDO.
   Define var readonly as logical       NO-UNDO.
   Define var mod      as logical              NO-UNDO.

  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.


   if s_Adding then
      /* Add is modal - current-window is already set */
      widg = b_Field._Field-name:HANDLE in frame newfld.
   else do:
      widg = b_Field._Field-name:HANDLE in frame fldprops.
      current-window = s_win_Fld.
   end.

   run as4dict/_blnknam.p
      (INPUT widg, INPUT "field", OUTPUT no_name).
   if no_name then return NO-APPLY.

   run as4dict/_fldsas.p (INPUT s_Fld_ReadOnly, 
                                           BUFFER b_Field, OUTPUT mod).
   if mod AND NOT s_Adding then do:
      {as4dict/setdirty.i &Dirty = "true"}.     
      find as4dict.p__File where as4dict.p__File._File-number = s_TblForNo.         
      as4dict.p__File._Fil-Res1[8] = 1.
      if s_btn_Close:label in frame fldprops <> "Close" then
               s_btn_Close:label in frame fldprops = "Close".
   end.
end.

/*----- LEAVE of NAME FIELD -----*/
on leave of b_Field._Field-Name in frame newfld,
            b_Field._Field-Name in frame fldprops
                
do:
   Define var okay           as logical.
   Define var name           as char.
   Define var aname     as char.
   Define var win            as widget-handle.

   if s_Adding then
      display "" @ s_Status with frame newfld.  /* clear status after add */

   win = (if s_CurrObj = {&OBJ_FLD} then s_win_Fld else s_win_Dom).
   run as4dict/_leavnam.p (INPUT  b_Field._Field-Name, 
                           INPUT win,
                           INPUT b_Field._Fld-number,
                           INPUT {&OBJ_FLD}, 
                           OUTPUT name, 
                           OUTPUT okay).

   if okay = ? then return.
   if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.

   if NOT s_Adding AND s_Fld_InView then
   do:
      message "This field is used in a view - you cannot rename it."
                     view-as ALERT-BOX ERROR buttons Ok.
      s_Valid = no.
      return NO-APPLY.
   end. 
  
   /* Default the AS400 Field Name.  If it has no value, default it
   to the field-name in upper-case.  */       

   if s_Adding then 
   do:       
       aname = input frame newfld b_Field._For-Name.
       if aname = "" OR aname = ? then
       do:                               
          b_Field._For-Name:screen-value in frame newfld = CAPS(name).   
           apply "leave" to b_Field._For-Name in frame newfld.
       end.
    end.
end.

/*----- LEAVE of AS400 Field Name NAME -----*/
on leave of b_Field._For-Name in frame newfld,
                  b_Field._For-Name in frame fldprops
do:                                          
   Define var aname as char NO-UNDO.
   Define var name  as char NO-UNDO.
   Define var okay  as logical NO-UNDO.
   Define var win            as widget-handle.
      
   aname = TRIM(SELF:screen-value).
   /* If we're editing and name hasn't changed, then it's OK */
   if NOT s_Adding AND aname = b_Field._For-name  then
      return.
  IF s_adding AND aname = "" THEN RETURN.
  if s_Adding then
      display "" @ s_Status with frame newfld.  /* clear status after add */  
      
  win = (if s_CurrObj = {&OBJ_FLD} then s_win_Fld else s_win_Dom).
 
  run as4dict/_lva4nam.p (INPUT b_Field._For-Name, INPUT win,
                                             OUTPUT name, OUTPUT okay).                                             
  if okay = ? then return.
  if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.                                       
end.                      


/*---- COMBO BOX TRIGGERS for DATA TYPE -----*/
{adecomm/cbtdrop.i &Frame  = "frame fldprops"
                   &CBFill = "s_Fld_DType"
                   &CBList = "s_lst_Fld_DType"
                   &CBBtn  = "s_btn_Fld_DType"
                   &CBInit = """"}


/*----- CHANGE of DATA TYPE FIELD -----*/
on /* leave */ U1 of s_Fld_DType in frame fldprops, 
                     s_lst_Fld_DType in frame fldprops
do:
   /* Set other field defaults based on the datatype chosen.  You CAN
      change data types for some gateways.
   */
   
  ASSIGN s_Fld_DType = s_Fld_DType:screen-value in frame fldprops
         user_env[35] = "DTF".
       
   run as4dict/FLD/udfltfmt.p   
      (INPUT b_Field._Format:HANDLE in frame fldprops,
       INPUT b_Field._Initial:HANDLE in frame fldprops,
       INPUT s_Fld_Var_Length:HANDLE in frame fldprops,
       INPUT true).  
    ASSIGN user_env[35] = "".    
end.


/*----- LEAVE of FORMAT FIELD -----*/
on leave of b_Field._Format in frame fldprops
do:
   /* Set format to default if it's blank and fix up initial value
      if data type is logical based on the format. */
 
   IF user_env[35] = "DTF" THEN.
   ELSE IF user_env[22] = "committed" THEN.
   ELSE     
     run as4dict/FLD/udfltfmt.p   
        (INPUT b_Field._Format:HANDLE in frame fldprops,
         INPUT b_Field._Initial:HANDLE in frame fldprops,
         INPUT s_Fld_Var_Length:HANDLE in frame fldprops,
         INPUT false).  
end.

/*----- HIT of FORMAT EXAMPLES BUTTON -----*/
on choose of s_btn_Fld_Format in frame fldprops
do:
   Define var fmt as char NO-UNDO.

   /* If adding current window is already set since dlg is modal */
   if NOT s_Adding then current-window = s_win_Fld.

   /* Allow user to pick a different format from examples */
   fmt = input frame fldprops b_Field._Format.
   run as4dict/FLD/_fldfmts.p (INPUT s_Fld_Typecode, INPUT-OUTPUT fmt).
   b_Field._Format:SCREEN-VALUE in frame fldprops = fmt.
end.       

/*----------Leave of Order Field -------------------------*/
on leave of b_Field._Order          in frame newfld,
                   b_Field._Order in frame fldprops
do:
    if s_Adding  then do:
        FIND FIRST as4dict.p__Field where as4dict.p__Field._File-number = b_field._File-number
                                                          and as4dict.p__Field._Order = input frame newfld b_Field._Order
                                                          and as4dict.p__Field._Fld-number <> b_Field._Fld-number
                                                          NO-LOCK NO-ERROR.
        IF AVAILABLE as4dict.p__Field THEN DO:
            message "A field already exists with entered order number."
                view-as alert-box Error button Ok.
            s_Valid = no.
            return NO-APPLY.
        END.                
    END.
    ELSE DO:
      FIND FIRST as4dict.p__Field where as4dict.p__Field._File-number = b_field._File-number
                                                          and as4dict.p__Field._Order = input frame fldprops b_Field._Order
                                                          and as4dict.p__Field._Fld-number <> b_Field._Fld-number
                                                          NO-LOCK NO-ERROR.
        IF AVAILABLE as4dict.p__Field THEN DO:
            message "A field already exists with entered order number."
                view-as alert-box Error button Ok.
            s_Valid = no.
            return NO-APPLY.
        END.        
     END.              
END.               

/*-----ON CHOOSE OF VARIABLE LENGTH--------*/        
on value-changed of s_fld_var_length in frame fldprops
do:
    IF SELF:screen-value = "yes" then
    do:
      ASSIGN b_Field._For-allocated:sensitive in frame fldprops = true
             b_Field._For-allocated:screen-value = "1"
             fldmisc1[6] = 1.
       apply "entry" to b_Field._For-allocated in frame fldprops.
     end.
     else
        assign b_field._For-allocated:sensitive in frame fldprops = false
               b_field._For-allocated:screen-value in frame fldprops = "0"
               fldmisc1[6] = 0.
end.                       

/* ---VERIFY VARIABLE LENGTH------*/
 on leave of b_Field._For-allocated in frame fldprops
 do:
    IF input frame fldprops b_Field._For-allocated >= input frame fldprops b_Field._Fld-stlen
        then do:
            MESSAGE  " Allocated length must be less than field length." SKIP
            VIEW-AS ALERT-BOX ERROR BUTTON OK.
           return NO-APPLY.
      end.
 end.
 
/*----- VALUE-CHANGED of ARRAY TOGGLE -----*/
on value-changed of s_Fld_Array in frame fldprops
do:
   if SELF:screen-value = "yes" then
   do:
      b_Field._Extent:sensitive in frame fldprops = true.
      b_Field._Extent:screen-value = "1".  /* default to non-zero value */
      apply "entry" to b_Field._Extent in frame fldprops.
   end.
   else 
      assign
      	 b_Field._Extent:sensitive in frame fldprops = false
      	 b_Field._Extent:screen-value in frame fldprops = "0".
end.


    
/*====================Triggers for Sequence Properties=======================*/

/* Some sequence triggers (Save button, GO from create, leave increment */
{as4dict/SEQ/seqtrig.i &frame = "frame seqprops"}


/*----- END-ERROR OR CLOSE BUTTON of SEQPROPS FRAME -----*/
on END-ERROR of frame seqprops OR choose of s_btn_Close in frame seqprops
do:
   {as4dict/delwin.i &Win = s_win_Seq &Obj = {&OBJ_SEQ}}
   return NO-APPLY.  /* otherwise everything will be undone! */
end.


/*----- HIT of OK BUTTON or GO -----*/
on GO of frame seqprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   run as4dict/SEQ/_saveseq.p
      (b_Sequence._Seq-name:HANDLE in frame seqprops,
       input frame seqprops b_Sequence._Seq-Incr,
       input frame seqprops s_Seq_Limit,
       b_Sequence._Seq-Init:HANDLE in frame seqprops,
       input frame seqprops s_Seq_Cycle_Ok).

   if RETURN-VALUE = "error" then
      return NO-APPLY.

   {as4dict/delwin.i &Win = s_win_Seq &Obj = {&OBJ_SEQ}}
end.


/*----- HIT of SAVE BUTTON -----*/
on choose of s_btn_Save in frame seqprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   run as4dict/SEQ/_saveseq.p
      (b_Sequence._Seq-name:HANDLE in frame seqprops,
       input frame seqprops b_Sequence._Seq-Incr,
       input frame seqprops s_Seq_Limit,
       b_Sequence._Seq-Init:HANDLE in frame seqprops,
       input frame seqprops s_Seq_Cycle_Ok).
   IF (RETURN-VALUE <> "error" AND
       s_btn_Close:label in frame seqprops <> "Close") then
      s_btn_Close:label in frame seqprops = "Close".
end.


/*----- HIT of NEXT button -----*/
on choose of s_btn_Next in frame seqprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   run as4dict/_nextobj.p ({&OBJ_SEQ}, true).
end.


/*----- HIT of PREV button -----*/
on choose of s_btn_Prev in frame seqprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   run as4dict/_nextobj.p ({&OBJ_SEQ}, false).
end.


/*----- HELP in SEQPROPS FRAME -----*/
on HELP of frame seqprops OR choose of s_btn_Help in frame seqprops 
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", 
                                               {&AS4_Sequence_Properties_Window}, ?).


/*----- LEAVE of NAME FIELD -----*/
on leave of b_Sequence._Seq-Name in frame newseq,
                  b_Sequence._Seq-Name in frame seqprops
do:
   Define var okay as logical.
   Define var name as char.

   if s_Adding then
      display "" @ s_Status with frame newseq.  /* clear status after add */

   run as4dict/_leavnam.p (INPUT  b_Sequence._Seq-Name, 
                           INPUT  s_win_Seq, 
                           INPUT 0,
                           INPUT {&OBJ_SEQ},
                           OUTPUT name, 
                           OUTPUT okay).
   if okay = ? then return.
   if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.
end.


/*----- LEAVE of SAVE BUTTON -----*/
on leave of s_btn_Save in frame seqprops
   display "" @ s_Status with frame seqprops. /* clear status line */


/*=====================Triggers for Index Properties======================*/

/*----- END-ERROR OR CLOSE BUTTON of IDXPROPS FRAME -----*/
on END-ERROR of frame idxprops OR choose of s_btn_Close in frame idxprops
do:               

   {as4dict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
   return NO-APPLY.  /* otherwise everything will be undone! */
end.


/*----- HIT of SAVE BUTTON -----*/
on choose of s_btn_Save in frame idxprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   run as4dict/IDX/_saveidx.p.
   IF (RETURN-VALUE <> "error" AND
       s_btn_Close:label in frame idxprops <> "Close") then
      s_btn_Close:label in frame idxprops = "Close".
end.


/*----- HIT of OK BUTTON or GO -----*/
on GO of frame idxprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   run as4dict/IDX/_saveidx.p.
   if RETURN-VALUE = "error" then
      return NO-APPLY.

   {as4dict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
end.


/*----- LEAVE of SAVE BUTTON -----*/
on leave of s_btn_Save in frame idxprops
   display "" @ s_Status with frame idxprops. /* clear status line */


/*----- HIT of NEXT button -----*/
on choose of s_btn_Next in frame idxprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   run as4dict/_nextobj.p ({&OBJ_IDX}, true).
end.


/*----- HIT of PREV button -----*/
on choose of s_btn_Prev in frame idxprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.

   run as4dict/_nextobj.p ({&OBJ_IDX}, false).
end.


/*----- HELP in IDXPROPS FRAME -----*/
on HELP of frame idxprops OR choose of s_btn_Help in frame idxprops 
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", {&AS4_Index_Properties_Window}, ?).


/*----- LEAVE of NAME FIELD -----*/
on leave of b_Index._Index-Name in frame newidx,
                  b_Index._Index-Name in frame idxprops
do:
   Define var okay as logical.
   Define var name as char.   
   Define var aname as char.

   if s_Adding then
      display "" @ s_Status with frame newidx.  /* clear status after add */

   run as4dict/_leavnam.p (INPUT  b_Index._Index-Name,
                           INPUT  s_win_Idx,
                           INPUT  0,
                           INPUT {&OBJ_IDX}, 
                           OUTPUT name, 
                           OUTPUT okay).
   if okay = ? then return.
   if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.   
   
      /* Default the AS400 Index Name.  If it has no value, default it
   to the field-name in upper-case.  */         
   if s_Adding then 
   do:                                         
       aname = input frame newidx b_Index._AS4-File.
       if aname = "" OR aname = ? then
       do:
          b_Index._AS4-File:screen-value in frame newidx = CAPS(name).
          apply "entry" to b_Index._AS4-File in frame newidx.
       end.
    end.
end.                 

/*-----ENTRY of AS400 Index Name ----*/
on entry of b_Index._AS4-file in frame newidx,
                      b_Index._AS4-File in frame idxprops
do:
   Define var aname as char NO-UNDO.
   Define var name  as char NO-UNDO.
   Define var okay  as logical NO-UNDO.
   
   aname = TRIM(SELF:screen-value).
   if s_Adding then
      display "" @ s_Status with frame newidx.  /* clear status after add */       

  run as4dict/_lva4nam.p (INPUT b_Index._AS4-file, INPUT s_win_Idx,
                                             OUTPUT name, OUTPUT okay).                  
    if name = ? then name = input frame newidx b_Index._AS4-File.                                         
end.

/*----- LEAVE of AS400 Index Name -----*/
on leave of  b_Index._AS4-file  in frame newidx ,
                        b_Index._AS4-File in frame idxprops
do:
   Define var aname as char NO-UNDO.
   Define var name  as char NO-UNDO.
   Define var okay  as logical NO-UNDO.
  
   aname = CAPS(TRIM(SELF:screen-value)).
   if s_Adding then
      display "" @ s_Status with frame newidx.  /* clear status after add */       
    
    if length(aname) = 0 then do:
          message "An AS/400 Name is required."
               view-as ALERT-BOX ERROR
               buttons OK.
        s_Valid = no.
        return NO-APPLY.
     end.    
 
      if s_Adding OR input frame idxprops b_Index._AS4-file entered then do:        
        run as4dict/_lva4nam.p (INPUT b_Index._AS4-file, INPUT s_win_Idx,
                                             OUTPUT name, OUTPUT okay).                  
        if name = ? and s_Adding then  do:
            name = input frame newidx b_Index._AS4-File.  
             b_Index._AS4-File:screen-value in frame newidx = CAPS(name).
        end.     
        else if name = ? then do:
            name = input frame idxprops b_Index._AS4-file.    
            b_Index._AS4-File:screen-value in frame idxprops = CAPS(name).                                       
         end.              
          if can-find(as4dict.p__Index where as4dict.p__Index._AS4-File =  name
                   AND as4dict.p__Index._AS4-Library = b_Index._AS4-Library )
          then   do:         
             message "An index with this name already exists for this database."
               view-as ALERT-BOX ERROR
               buttons OK.
                s_Valid = no.
                return NO-APPLY.
          end.        
     end.       
     else assign okay = true
                            name = aname.                       

  if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.                                         
end.   

/*======================Triggers for Procedure Properties=======================*/

/*----- END-ERROR OR CLOSE BUTTON of PRCPROPS FRAME -----*/
on END-ERROR of frame prcprops OR choose of s_btn_Close in frame prcprops
do: 
    {as4dict/delwin.i &Win = s_win_Proc &Obj = {&OBJ_PROC}}                         
   return NO-APPLY.  /* otherwise it will undo everything! */
end.

/*----- HIT of SAVE BUTTON -----*/
on choose of s_btn_Save in frame prcprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.
  run as4dict/prc/_saveprc.p. 
  IF (RETURN-VALUE <> "error" AND
    s_btn_Close:label in frame prcprops <> "Close") then
      s_btn_Close:label in frame prcprops = "Close".
end.

/*----- HIT of OK BUTTON or GO -----*/
on GO of frame prcprops
do:                           

    if input frame prcprops s_AS400_Proc_name <> b_Proc._AS4-File then        
         apply "leave" to s_AS400_Proc_name in frame prcprops. 
   
   run as4dict/prc/_saveprc.p.
   if RETURN-VALUE = "error" then
      return NO-APPLY.
    {as4dict/delwin.i &Win = s_win_Proc &Obj = {&OBJ_PROC}}   
end.

/*----- LEAVE of NAME FIELD -----*/
on leave of b_Proc._File-Name in frame newproc,
            b_Proc._File-name in frame prcprops do:
            
   Define var okay  as logical NO-UNDO.
   Define var name  as char    NO-UNDO.
   Define var dname as char    NO-UNDO.
   Define var aname as char    NO-UNDO.

   if s_Adding then
      display "" @ s_Status with frame newproc.  /* clear status after add */

   run as4dict/_leavnam.p (INPUT b_Proc._File-Name, 
                           INPUT s_win_Proc,
                           INPUT b_Proc._File-number,
                           INPUT {&OBJ_PROC},
                           OUTPUT name, 
                           OUTPUT okay).             
                                         
   if okay = ? then return.
   if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.
end.
/*----- LEAVE of AS400 Proc Name NAME -----*/
on leave of s_AS400_Proc_Name in frame newproc do:
   Define var aname as char NO-UNDO.
   Define var name  as char NO-UNDO.
   Define var okay  as logical NO-UNDO.
 
   aname = TRIM(SELF:screen-value).
   display "" @ s_Status with frame newproc.  /* clear status after add */

   run as4dict/_lva4nam.p (INPUT  aname, INPUT s_win_Proc,
                             OUTPUT name, OUTPUT okay).   
                                                                            
   s_AS400_Proc_Name:screen-value in frame newproc = CAPS(NAME).
                                                          
  if okay = ? then return.                                                                            

  if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.                                       
   IF LENGTH(name) > 0  THEN DO:                                                
     IF LENGTH(name) < 10  THEN
        b_Proc._For-Format = CAPS(name) + "R".
     ELSE
       b_Proc._For-Format = SUBSTRING(CAPS(name),1,9) + "R".     
   END.
end.
/*------LEAVE OF AS4-LIBRARY-NAME ----*/
on leave of s_AS400_Libr_Name in frame newproc,
            s_AS400_Libr_Name in frame prcprops
do:
  Define var lname as char NO-UNDO.
  Define var lib         as char NO-UNDO.   
  Define var okay    as logical NO-UNDO.     

   lname = TRIM(SELF:screen-value).                  
        
   if (lname = "?" OR lname = "") then
   do:
      message "Library name is required" 
      VIEW-AS ALERT-BOX Error BUTTON OK.
    
      s_Valid = no.
      return NO-APPLY.
   END.          
   lname = CAPS(lname).                                         
   if s_Adding then  do:    
   /* if we're editing and name hasn't changed then it's OK */

     display "" @ s_Status with frame newproc.  /* clear status after add */   
   
     run as4dict/_libnam.p (INPUT lname, INPUT s_win_Proc,  
                            INPUT input frame newproc s_AS400_Proc_name,   
                            OUTPUT lname, OUTPUT okay).                                                  
     if okay then  
       dba_unres = true.              

     else do:
       s_Valid = no.    
       s_OK_Hit = no.                        
       return NO-APPLY.             
     end.            
   end.                                                                    
   else do:                
        /* if we're editing and name hasn't changed then it's OK */
      if  lname = b_proc._AS4-Library 
       AND CAPS(b_proc._AS4-File) = CAPS(input frame prcprops s_AS400_Proc_name) then
            return.        
            
     display "" @ s_Status with frame prcprops.  /* clear status after add */                   
       
     run as4dict/_libnam.p (INPUT lname, INPUT s_win_Proc,  
                            INPUT input frame prcprops s_AS400_Proc_name,
                            OUTPUT lname, OUTPUT okay).       
     if okay then 
        dba_unres = true.                                                                                                
     else do:
        ASSIGN s_Valid = NO
               s_OK_Hit = no.                        
        RETURN NO-APPLY.             
     end.  
  end.                                                                   
end.

/*----- HIT of NEXT button -----*/
on choose of s_btn_Next in frame prcprops
do:
   RUN as4dict/forceval.p.  /* force leave trigger to fire */
   IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.
   run as4dict/_nextobj.p ({&OBJ_PROC}, true).
end.


/*----- HIT of PREV button -----*/
on choose of s_btn_Prev in frame prcprops
do:
   run as4dict/forceval.p.  /* force leave trigger to fire */
   IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.
   run as4dict/_nextobj.p ({&OBJ_PROC}, false).
end.


/*----- LEAVE of SAVE BUTTON -----*/
on leave of s_btn_Save in frame prcprops
   /* Since status is displayed only after save is hit */
   display "" @ s_Status with frame prcprops. /* clear status line */


/*----- HELP in PRCPROPS FRAME -----*/
on HELP of frame prcprops OR choose of s_btn_Help in frame prcprops 
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", {&AS4_Proc_Properties_Window}, ?).

/*==================Triggers for Parameters======================*/

/*----- END-ERROR OR CLOSE BUTTON of parmprops FRAME -----*/
on END-ERROR of frame parmprops OR choose of s_btn_Close in frame parmprops
do:
    {as4dict/delwin.i &Win = s_win_Parm &Obj = {&OBJ_PARM}}
   return NO-APPLY.  /* otherwise it will undo everything! */
end.

/*----- HIT of NEXT button -----*/
on choose of s_btn_Next in frame parmprops
do:
  run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.
   run as4dict/_nextobj.p ({&OBJ_PARM}, true).
end.


/*----- HIT of PREV button -----*/
on choose of s_btn_Prev in frame parmprops
do:
   run as4dict/forceval.p.  /* force leave trigger to fire */
  IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.
   run as4dict/_nextobj.p ({&OBJ_PARM}, false).
end.



/*----- HIT of SAVE BUTTON -----*/
on choose of s_btn_Save in frame parmprops
do:

   run as4dict/forceval.p.   /* force leave trigger to fire */  
   IF RETURN-VALUE = "redo" THEN
    RETURN NO-APPLY.  
    run as4dict/parm/_saveprm.p.
     
   IF (RETURN-VALUE <> "error" AND
      s_btn_Close:label in frame parmprops <> "Close") then
      s_btn_Close:label in frame parmprops = "Close".
end.


/*----- HIT of OK BUTTON or GO -----*/
on GO of frame parmprops
do:        
 
   run as4dict/parm/_saveprm.p.
   
   if RETURN-VALUE = "error" then
      return NO-APPLY.
   {as4dict/delwin.i &Win = s_win_Parm &Obj = {&OBJ_PARM}}   
end.

/*----- LEAVE of NAME FIELD -----*/
on leave of b_Parm._Field-Name in frame parmprops                
do:
   Define var okay     as logical.
   Define var name     as char.
   Define var aname    as char.
   Define var win      as widget-handle.

   win =  s_win_Parm.
   run as4dict/_leavnam.p (INPUT  b_Parm._Field-Name, 
                           INPUT win, 
                           INPUT b_Parm._Fld-number,
                           INPUT {&OBJ_FLD},
                           OUTPUT name, 
                           OUTPUT okay).
   if okay = ? then return.
   if NOT okay then do:
      s_Valid = no.
      return NO-APPLY.
   end.   
end.

/*----- LEAVE of FORMAT FIELD -----*/
on leave of b_Parm._Format in frame parmprops
do:
   /* Set format to default if it's blank and fix up initial value
      if data type is logical based on the format. */
 
   IF user_env[35] = "DTF" THEN.
   ELSE IF user_env[22] = "committed" THEN.
   ELSE     
     run as4dict/parm/udfltfmt.p   
        (INPUT b_Parm._Format:HANDLE in frame parmprops,
         INPUT b_Parm._Initial:HANDLE in frame parmprops,
         INPUT false).  
end.

/*----- HIT of FORMAT EXAMPLES BUTTON -----*/
on choose of s_btn_Parm_Format in frame parmprops
do:
   Define var fmt as char NO-UNDO.

   /* If adding current window is already set since dlg is modal */
   if NOT s_Adding then current-window = s_win_Parm.

   /* Allow user to pick a different format from examples */
   fmt = input frame parmprops b_Parm._Format.
   run as4dict/FLD/_fldfmts.p (INPUT s_Parm_Typecode, INPUT-OUTPUT fmt).
   b_Parm._Format:SCREEN-VALUE in frame parmprops = fmt.
end.       

/*----------Leave of Order Field -------------------------*/
on leave of b_Parm._Order in frame parmprops
do:    
  FIND FIRST as4dict.p__Field where as4dict.p__Field._File-number = b_Parm._File-number
                                and as4dict.p__Field._Order = input frame parmprops b_Parm._Order
                                and as4dict.p__Field._Fld-number <> b_Parm._Fld-number
                                NO-LOCK NO-ERROR.
  IF AVAILABLE as4dict.p__Field THEN DO:
    message "A parameter already exists with entered order number."
          view-as alert-box Error button Ok.
    s_Valid = no.
    return NO-APPLY.
  END.                      
END.

/*----- HELP in PARMPROPS FRAME -----*/
on HELP of frame parmprops OR choose of s_btn_Help in frame parmprops 
   RUN "adecomm/_adehelp.p" ("as4d", "CONTEXT", {&AS4_Parm_Properties_Window}, ?).
