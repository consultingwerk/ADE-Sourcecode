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

File: _dbcreat.p

Description:   
   Put up a dialog box to get parameters for creating a new database.
   Then create the database by calling prodb.  This routine will display
   any necessary error messages to the user.

Input Parameter:
   p_olddb   - Suggested name of database to copy from.  The user can 
               change this.  This should be either "Sports", "empty", or
               some other physical db name.  Or it can be the null string.
  
Input-Output Parameter:
   p_newdb   - On input, this can be the suggested name of the new database or
      	       it can be the null string.  On output, if a new database was
      	       created successfully, this is set to the name of the new database.
      	       It is set to ? if an error occurred or if the user pressed
      	       Cancel.

Author: Laura Stern

Date Created: 01/27/92

Modified on 10/6/95 by gfs - Added initial value to radio-set.
            04/12/00 DLM - Added longer db name support
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/commeng.i}  /* Help contexts */
{adecomm/adestds.i}  /* standard form layout, color and font defines */

Define INPUT   	    PARAMETER p_olddb as char.
Define INPUT-OUTPUT PARAMETER p_newdb as char NO-UNDO.

Define var sysdb as char NO-UNDO INITIAL "Empty"
   view-as radio-set
   radio-buttons "An &EMPTY Database",       	"Empty",
      	         "A Copy of the &SPORTS Database",  "Sports",
      	         "A Copy of Some &Other Database",  "Other".

Define var otherdb as char    NO-UNDO.
Define var replace as logical NO-UNDO INIT NO view-as TOGGLE-BOX.

/* Buttons */
Define button btn_Filen  label "&Files..." 
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SIZE 15 by 1.125 &ENDIF .
Define button btn_Fileo  label "Files..." 
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN SIZE 15 by 1.125 &ENDIF .
Define button btn_Ok 	 label "OK"       {&STDPH_OKBTN}.
Define button btn_Cancel label "Cancel"   {&STDPH_OKBTN} AUTO-ENDKEY.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   Define button    btn_Help  label "&Help" {&STDPH_OKBTN}.
   Define rectangle rect_Btns {&STDPH_OKBOX}. /* standard button rectangle */
   &global-define   HLP_BTN  &HELP = "btn_Help"
&ELSE
   &global-define   HLP_BTN  
&ENDIF

Define var stat        as logical NO-UNDO. 
Define var p_newdb_lbl as char format "x(35)" no-undo
  init "&New Physical Database Name:".

FORM 
   SKIP({&TFM_WID})  
   p_newdb_lbl  NO-LABEL VIEW-AS TEXT            AT 2  SKIP({&VM_WID})
   p_newdb      NO-LABEL    	       	     at 4   
      	        format "x({&PATH_WIDG})" {&STDPH_FILL}
      	        view-as fill-in size 37 by 1 	   SPACE(.3)
   btn_Filen   	     	      	       	     	   SKIP({&VM_WID})
   "(.db extension can be omitted)":t34 
      	        view-as TEXT                    at 4   SKIP({&VM_WIDG}) 

   "Start with:":t17 view-as TEXT  	  	     at 2   SKIP({&VM_WID})
   sysdb       	NO-LABEL      	       	     at 2   SKIP({&VM_WID})

   otherdb      NO-LABEL     	       	     at 4   
      	        format "x({&PATH_WIDG})" {&STDPH_FILL}
      	        view-as fill-in native size 37 by 1     SPACE(.3)
   btn_Fileo   	     	      	       	     	    SKIP({&VM_WIDG})  

   replace      LABEL "&Replace If Exists"       at 2

   {adecomm/okform.i
      &BOX    = rect_btns
      {&HLP_BTN}
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
   }

   with frame dbcreate 
   SIDE-LABELS CENTERED 
   DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   TITLE "Create Database" view-as DIALOG-BOX.

/* Associate text widget with fill-in label to enable mnemonic (Nordhougen 07/26/95) */
ASSIGN
  p_newdb:SIDE-LABEL-HANDLE IN FRAME dbcreate = p_newdb_lbl:HANDLE
  p_newdb:LABEL IN FRAME dbcreate = p_newdb_lbl.

/*============================ Internal Procedures =================================*/

Procedure Get_Db_Name:
   Define INPUT PARAMETER h_name  as widget-handle NO-UNDO.
   Define INPUT PARAMETER p_exist as logical       NO-UNDO. /* must exist */

   Define var name       as char    NO-UNDO.
   Define var picked_one as logical NO-UNDO.
   Define var d_title    as char    NO-UNDO init "Find Database File".

   name = TRIM(h_name:screen-value).
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      if p_exist then
      	 system-dialog GET-FILE 
	    name 
	    filters            "*.db" "*.db"
	    default-extension  ".db"
	    title 	       d_title 
	    must-exist
	    update             picked_one.
      else
      	 system-dialog GET-FILE 
	    name 
	    filters            "*.db" "*.db"
	    default-extension  ".db"
	    title 	       d_title 
	    update             picked_one.
   &ELSE
      run adecomm/_filecom.p
	  ( INPUT "*.db",  /* p_Filter */
	    INPUT "", 	   /* p_Dir */
	    INPUT "", 	   /* p_Drive */
	    INPUT no,	   /* File Open */
	    INPUT d_title,
            INPUT (if p_exist then "MUST-EXIST" else ""), /* Dialog Options */
	    INPUT-OUTPUT name,
   	    OUTPUT picked_one). 
   &ENDIF

   if picked_one then
      h_name:screen-value = name.
end.


/*============================== Triggers ====================================*/

/*-----------HIT of OK BUTTON---------*/
on choose of btn_OK in frame dbcreate OR GO of frame dbcreate
do:
   Define var err as integer NO-UNDO.

   assign
     input frame dbcreate p_newdb
     input frame dbcreate sysdb
     input frame dbcreate replace.
   
   p_newdb = TRIM(p_newdb).
   p_newdb:screen-value in frame dbcreate = p_newdb.

   if sysdb = "Other" then
      assign p_olddb = TRIM(input frame dbcreate otherdb).
   else
      assign p_olddb = sysdb.

   if p_olddb = "" or p_newdb = "" then 
   do:
      message "You must specify a database name for both" SKIP
       	      "the source and the destination databases."
      	 view-as ALERT-BOX ERROR buttons OK.
      apply "entry" to p_newdb in frame dbcreate.
      return NO-APPLY.
   end.

   run adecomm/_setcurs.p ("WAIT").
   if replace then
      create database p_newdb from p_olddb replace NO-ERROR.
   else
      create database p_newdb from p_olddb NO-ERROR.
   run adecomm/_setcurs.p ("").

   if error-status:get-message(1) = "" then
      return.

   message error-status:get-message(1) view-as alert-box error buttons ok.
   p_newdb = ?.  /* flag that error occured. */
   return NO-APPLY.  /* let user cancel out after seeing error */
end.


/*-----HIT of CANCEL, ENDKEY-----*/
on ENDKEY,END-ERROR of frame dbcreate  /* or cancel which is auto-endkey */
   p_newdb = ?.


/*----- WINDOW-CLOSE-----*/
on WINDOW-CLOSE of frame dbcreate
do:
   p_newdb = ?.
   apply "END-ERROR" to frame dbcreate.
end.

/*-----SELECTION of a sysdb RADIO-ITEM-----*/
on value-changed of sysdb in frame dbcreate
do:
   /* Either hide or enable the "other" fill-in field based on the
      radio button selection. */

   if sysdb:screen-value in frame dbcreate = "Other" then
   do:
      assign
      	 &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
      	    otherdb:visible in frame dbcreate = yes
      	    btn_Fileo:visible in frame dbcreate = yes.
     	 &ELSE
      	    otherdb:sensitive in frame dbcreate = yes
      	    btn_Fileo:sensitive in frame dbcreate = yes.
      	 &ENDIF
      apply "entry" to otherdb in frame dbcreate. 
   end.
   else
      assign
      	 otherdb:screen-value in frame dbcreate = ""
      	 &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
      	    otherdb:visible in frame dbcreate = no
      	    btn_Fileo:visible in frame dbcreate = no.
      	 &ELSE
      	    otherdb:sensitive in frame dbcreate = no
      	    btn_Fileo:sensitive in frame dbcreate = no.
      	 &ENDIF
end.


/*----- HIT of New FILE BUTTON -----*/
on choose of btn_Filen in frame dbcreate
   run Get_Db_Name (INPUT p_newdb:HANDLE in frame dbcreate, INPUT no).
   

/*----- HIT of Other FILE BUTTON -----*/
on choose of btn_Fileo in frame dbcreate
   run Get_Db_Name (INPUT otherdb:HANDLE in frame dbcreate, INPUT yes).


/*----- HELP -----*/
on HELP of frame dbcreate
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      OR choose of btn_Help in frame dbcreate
   &ENDIF
   RUN "adecomm/_adehelp.p" (INPUT "comm", INPUT "CONTEXT", 
      	       	     	     INPUT {&Create_Database},
      	       	     	     INPUT ?).


/*============================= Mainline code ==============================*/

/* "Other" database name fill-in starts insensitive by default */
assign
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
      otherdb:hidden in frame dbcreate = yes
      btn_Fileo:hidden in frame dbcreate = yes
      otherdb:sensitive in frame dbcreate = yes
      btn_Fileo:sensitive in frame dbcreate = yes.
   &ELSE
      otherdb:sensitive in frame dbcreate = no
      btn_Fileo:sensitive in frame dbcreate = no.
   &ENDIF

/* Set defaults based on input parms */
if p_olddb = "empty" or p_olddb = "" or p_olddb = ? then
   sysdb:screen-value in frame dbcreate = "empty".
else if p_olddb = "sports" then
   sysdb:screen-value in frame dbcreate = "sports".
else
do:
   assign
      otherdb:screen-value in frame dbcreate = p_olddb
      sysdb:screen-value in frame dbcreate = "other"
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
      	 otherdb:hidden in frame dbcreate = no
      	 btn_Fileo:hidden in frame dbcreate = no.
      &ELSE
      	 otherdb:sensitive in frame dbcreate = yes
      	 btn_Fileo:sensitive in frame dbcreate = yes.
      &ENDIF
end.

assign
   p_newdb:screen-value in frame dbcreate = p_newdb
   replace:screen-value in frame dbcreate = "no".

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME  = "frame dbcreate" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   &CANCEL = "btn_Cancel"
   {&HLP_BTN}
}

/* Since the "otherdb" field isn't enabled to start, in order to get
   the tab order right, we can't use update.  Instead enable and reset
   tab position for "otherdb" and btn_Fileo.  Other widgets will be pushed
   down in the tab chain.
*/  

enable p_newdb 
       btn_Filen
       sysdb 
       replace
       btn_Ok
       btn_Cancel
       &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
       	 btn_Help
       &ENDIF
       with frame dbcreate.

assign
   stat = otherdb:move-after-tab-item(sysdb:HANDLE) in frame dbcreate
   stat = btn_Fileo:move-after-tab-item(otherdb:HANDLE) in frame dbcreate.

do ON ERROR UNDO,LEAVE  ON ENDKEY UNDO,LEAVE:
   Wait-for choose of btn_OK in frame dbcreate OR
      	    GO of frame dbcreate
      	    FOCUS p_newdb.
end.

hide frame dbcreate.
return.





