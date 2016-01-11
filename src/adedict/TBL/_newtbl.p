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

   Note: Currently only Progress files added through this code.
   All others are created via a gateway utility.  However, this is
   is set up to work for all gateways. 

Author: Laura Stern

Date Created: 03/13/92

History:
Added _Owner to _File finds D. McMann 07/14/98
Added support of Area names D. McMann 03/25/98
Modified on 12/07/94 by gfs - added support for ODBC
Modified on 07/08/94 by gfs - Bug 94-06-14-177 (again)
Modified on 07/07/94 by gfs - Bug 94-06-14-177
Mario B 12/28/98 Add s_In_Schema_Area enabling one time notification.
DLM      05/15/00 Removed warning message if only Schema Area in DB
Donna M. 04/23/02 Added assignment of new table recid variable 
10/01/02 DLM Changed check for SQL tables

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/TBL/tblvar.i shared}
{adedict/capab.i}


DEFINE VARIABLE capab  AS CHARACTER            NO-UNDO.
DEFINE VARIABLE added  AS LOGICAL   INITIAL no NO-UNDO.
DEFINE VARIABLE isodbc AS LOGICAL   INITIAL no NO-UNDO.
DEFINE VARIABLE num    AS INTEGER              NO-UNDO.
DEFINE VARIABLE curr_type as CHARACTER         NO-UNDO.
DEFINE VARIABLE ans AS LOGICAL NO-UNDO.

/*===============================Triggers====================================*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame newtbl
   apply "END-ERROR" to frame newtbl.


/*----- HIT of OK BUTTON -----*/
on choose of s_btn_OK in frame newtbl
   s_OK_Hit = yes.
   /* The GO trigger will fire after this. */


/*----- HIT of OK BUTTON or ADD BUTTON or GO -----*/
on GO of frame newtbl	/* or buttons - because they're auto-go */
do:
   Define var no_name  as logical NO-UNDO.
   Define var nxtname  as char    NO-UNDO.

   run adedict/_blnknam.p
      (INPUT b_File._File-name:HANDLE in frame newtbl,
       INPUT "table", OUTPUT no_name).
   if no_name then do:
      s_OK_Hit = no.  /* in case ok was hit */
      return NO-APPLY.
   end.
 
   IF NOT s_In_Schema_Area THEN DO:
     APPLY "LEAVE" TO s_Tbl_Area.
     IF NOT ans THEN DO:
        s_OK_Hit = no.  /* in case ok was hit */
        APPLY "ENTRY" TO s_Tbl_Area.
        return NO-APPLY.
     END.
   END.       

   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p ("WAIT").
    
      IF NOT s_Show_Hidden_Tbls AND input frame newtbl b_File._Hidden THEN DO:
            ASSIGN MENU-ITEM mi_Show_Hidden:CHECKED in MENU s_mnu_View = TRUE.
            APPLY "VALUE-CHANGED" TO MENU-ITEM mi_Show_Hidden in MENU s_mnu_View.
      END.

      ASSIGN b_File._DB-recid = s_DbRecId
             input frame newtbl b_File._File-name 
	         input frame newtbl b_File._Dump-Name
	         input frame newtbl b_File._Hidden
	         input frame newtbl b_File._For-Size
      	     input frame newtbl b_File._File-label
	         input frame newtbl b_File._Desc
             input frame newtbl b_File._Fil-misc2[6]
             n_tblrecid = RECID(b_File).
      
      FIND _Area WHERE _Area._Area-name = input frame newtbl s_Tbl_Area NO-LOCK.
      ASSIGN b_File._ianum = _Area._Area-num
             s_Tbl_Area = input frame newtbl s_tbl_area.
             
      if s_Tbl_Type:sensitive in frame newtbl then
      	 b_File._For-type = input frame newtbl s_Tbl_Type.
      if b_File._For-name:sensitive in frame newtbl then
      	 b_File._For-name = input frame newtbl b_File._For-name.
      
      /* For ODBC databases, the file's foreign type is "BUFFER"*/
      
      IF isodbc AND b_File._For-Name = ? AND b_File._For-Owner = ? THEN 
         ASSIGN 
            b_file._For-Type = "BUFFER" 
            b_File._For-Name = "NONAME".

      /* Add entry to tables list in alphabetical order */

      if s_Show_hidden_Tbls OR NOT b_File._Hidden then
      do:
      	 {adedict/TBL/nexttbl.i &Name = b_File._File-Name  
      	       	     	      	&Next = nxtname}
	 run adedict/_newobj.p
	    (INPUT s_lst_Tbls:HANDLE in frame browse,
	     INPUT b_File._File-name,
	     INPUT nxtname,
	     INPUT s_Tbls_Cached,
	     INPUT {&OBJ_TBL}).
      end.

      {adedict/setdirty.i &Dirty = "true"}.
      display "Table Created" @ s_Status with frame newtbl.
      added = yes.
      run adecomm/_setcurs.p ("").
      return.
   end.

   /* We only get here if an error occurred. Dialog box should remain
      on the screen so return NO-APPLY. */  
   run adecomm/_setcurs.p ("").
   s_OK_Hit = no.
   return NO-APPLY.  
end.


/*----- LEAVE of CREATE BUTTON -----*/
on LEAVE of s_btn_Add in frame newtbl
   display "" @ s_Status with frame newtbl. /* clear status line */


/*----- HELP -----*/
on HELP of frame newtbl OR choose of s_btn_Help in frame newtbl
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Create_Table_Dlg_Box}, ?).

/* ------on leave of s_Tbl_Area ----*/
ON LEAVE OF s_Tbl_Area in frame newtbl 
do:
  ASSIGN ans = FALSE.
  IF NOT s_In_Schema_Area AND num > 1 THEN DO:
    IF INPUT FRAME newtbl s_Tbl_Area = "Schema Area" THEN DO:
      MESSAGE "Progress Software Corporation does not recommend" SKIP
              "creating user tables in the Schema Area."  Skip(1)
              "Should tables be created in this area?" SKIP (1)
              VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE ans .
      IF ans THEN
        ASSIGN s_In_Schema_Area = TRUE.        
      ELSE DO:
        ASSIGN s_In_Schema_Area = TRUE.
        RETURN NO-APPLY.
      END.
    END.
    ASSIGN ans = TRUE.
  END.
  ELSE IF NOT s_In_Schema_Area AND INPUT FRAME newtbl s_Tbl_Area = "Schema Area" THEN DO:
    MESSAGE "Progress Software Corporation does not recommend" SKIP
            "putting user tables into the Schema Area. " SKIP (1)
            "See the System Administration Guide on how to" SKIP
            "create data areas." SKIP (1)
            VIEW-AS ALERT-BOX WARNING.
    ASSIGN s_In_Schema_Area = TRUE
           ans          = TRUE.
  END. 
  ELSE
    ASSIGN ans = TRUE.       
END.  
        
/*============================Mainline code==================================*/

find _File WHERE _File._File-name = "_File"
             AND _File._Owner = "PUB" NO-LOCK.
             
if NOT can-do(_File._Can-create, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "create tables."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

/* Get gateway capabilities */
run adedict/_capab.p (INPUT {&CAPAB_TBL}, OUTPUT capab).

if INDEX(capab, {&CAPAB_ADD}) = 0 then
do:
   message "You may not add a table definition for this database type."
      view-as ALERT-BOX ERROR buttons OK.
   return.
end.

/* Get ODBC types in case this is an ODBC db */
odbtyp = { adecomm/ds_type.i
           &direction = "ODBC"
           &from-type = "odbtyp"}.
           
/* See if this db is an ODBC db */      
IF CAN-DO(odbtyp, s_DbCache_Type[s_DbCache_ix]) THEN ASSIGN isodbc = yes.

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

s_Tbl_Type = s_DbCache_Type[s_DbCache_ix].

s_lst_file_area:list-items in frame newtbl = "".
FIND FIRST DICTDB._Area WHERE DICTDB._Area._Area-num > 6 
                          AND DICTDB._Area._Area-type = 6 NO-LOCK NO-ERROR.
IF AVAILABLE DICTDB._Area THEN
  ASSIGN s_Tbl_Area = DICTDB._AREA._Area-name.
ELSE DO:
  FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6 NO-LOCK.
  ASSIGN s_Tbl_Area = DICTDB._AREA._Area-name
         s_In_Schema_Area = TRUE.
END.  
  
for each DICTDB._Area WHERE DICTDB._Area._Area-num > 6 
                        AND DICTDB._Area._Area-type = 6 NO-LOCK:
  s_res = s_lst_file_Area:add-last(DICTDB._Area._Area-name) in frame newtbl.
END.

FIND DICTDB._Area WHERE DICTDB._Area._Area-num = 6 NO-LOCK.
  ASSIGN s_res = s_lst_file_Area:add-last(DICTDB._Area._Area-name) in frame newtbl.
  
num = s_lst_File_Area:num-items in frame newtbl.
s_Lst_File_Area:inner-lines in frame newtbl = (if num <= 5 then num else 5).  
 assign
      s_Tbl_Area:font  in frame newtbl = 0
      s_lst_File_Area:font in frame newtbl = 0
      s_Tbl_Area:width  in frame newtbl = 38
      s_lst_File_Area:width in frame newtbl = 38.

{adecomm/cbdrop.i &Frame  = "frame newtbl"
      	       	  &CBFill = "s_Tbl_area"
      	       	  &CBList = "s_lst_File_Area"
      	       	  &CBBtn  = "s_btn_File_area"
     	       	  &CBInit = """"}


/* cbtdrop.i is included in edittrig.i because of non-modal-ness. */
      {adecomm/cbcdrop.i &Frame  = "frame newtbl"
		         &CBFill = "s_Tbl_area"
		         &CBList = "s_lst_File_Area"
		     	 &CBBtn  = "s_btn_File_Area"
		     	 &CBInit = "curr_type"}

/* Each add will be a subtransaction */
s_OK_Hit = no.
add_subtran:
repeat ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
   /* Do this up top here, to be sure we committed the last create */
   if s_OK_Hit then leave add_subtran.

   if added AND s_btn_Done:label in frame newtbl <> "Close" then
      s_btn_Done:label in frame newtbl = "Close".

   create b_File.
   
/* moved enable statement to behind the create statement to avoid */
/* problems with buffer b_File <hutegger, 94/02/03> */
/* Note: the order of enables will govern the TAB order. */

   enable   
       b_File._File-Name
       s_Tbl_Area
       s_btn_File_area
       b_File._Dump-Name
       b_File._Hidden
       s_Tbl_Type          when INDEX(capab, {&CAPAB_TBL_TYPE_ADD}) > 0
       b_File._File-label
       b_File._Desc
       b_File._Fil-misc2[6]
       b_File._For-Size	   when INDEX(capab, {&CAPAB_CHANGE_TBL_SIZE}) > 0
       b_file._For-Name	   when INDEX(capab, {&CAPAB_CHANGE_FOR_NAME}) > 0
       s_btn_Tbl_Triggers
       s_btn_Tbl_Validation
       s_btn_Tbl_StringAttrs
       s_btn_OK
       s_btn_Add
       s_btn_Done
       s_btn_Help
       with frame newtbl.

assign s_Res = s_lst_File_Area:move-after-tab-item
      	       (s_btn_File_Area:handle in frame newtbl) in frame newtbl.

   /* Have to display all fields, so on 2nd or 3rd add, any entered values
      will be cleared. */
   display "" @ b_File._File-Name   /* display blank instead of ? */
           s_Tbl_Area
           s_btn_File_Area
           s_optional
      	   s_Tbl_Type
      	   "" @ b_File._Dump-Name
      	   b_File._Hidden
      	   b_File._Frozen
      	   b_File._File-label
      	   b_File._Desc
           b_File._Fil-misc2[6]
      	   b_File._For-Size when INDEX(capab, {&CAPAB_TBL_SIZE}) > 0

      	   (if INDEX(capab, {&CAPAB_FOR_NAME}) = 0 then
      	       "n/a"
      	    else
      	       b_File._For-Name
      	   ) @ b_File._For-Name

      	   (if INDEX(capab, {&CAPAB_OWNER}) = 0 then
      	       "n/a"
      	    else
      	       b_File._For-Owner
      	   ) @ b_File._For-Owner
 
          /* Display oracle dist. db status */
       
             IF INDEX(s_Tbl_Type,"ORACLE") = 0 then "n/a" ELSE IF 
             b_File._Fil-misc2[8] = ? THEN "<Local-Db>" ELSE
             b_File._Fil-misc2[8] @ b_File._Fil-misc2[8]
             
      	   with frame newtbl.

   wait-for choose of s_btn_OK, s_btn_Add in frame newtbl OR
      	    GO of frame newtbl
      	    FOCUS b_File._File-Name in frame newtbl.
end.
     

hide frame newtbl.

if s_OK_Hit then /* but not Create */
      apply "choose" to MENU-ITEM mi_Crt_Field in MENU s_mnu_Create.
return.


