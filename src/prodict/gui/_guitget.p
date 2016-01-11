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

File: _guitget.p

Description:   
   Select one or more tables. 

INPUT:
   user_env[1] MATCHES "*o*":
      If this program sees an "o" (for "optional") in user_env[1], then it
      returns immediately if a filename is currently set (other than
      "ALL").
   
   user_env[1] MATCHES "*a*":
      If this program sees an "a" (for "all"), then "ALL" is a valid
      choice.
   
   user_env[1] MATCHES "*s*":
      If this program sees an "s" (for "some"), then [Return] marks (or
      unmarks) names, and the comma-delimited list of names is returned in
      user_env[1].

OUTPUT:
   drec_file
      Contains the recid of the _File record selected, or no record if
      'ALL' or some entered.
   
   user_filename
   user_env[1]
      Contains the filename selected, or 'ALL', or a comma-separated list
      of filenames.  If a comma-sep list is returned in user_env[1], 'SOME'
      is returned in user_filename.
 
Author: Laura Stern

Date Created: 11/16/92 

History
   McMann D.    09/18/03    Added TTY to GUI and removed usrtget since it failed on large
                            number of files.
   McMann D.    04/21/00    Made sure ALL was not the only one in list
   McMann D.    01/25/00    Since ALL is not in the list when user_evn[1] = a
                            any table that started will all was being selected
                            as the table the user wanted.  If user_evn[1] = a I 
                            have added the literal "ALL" as the first table name
                            20000124001
   Mario B.     99/04/07    BUG 99-04-07-006.  In the case of the existence of
                            only 1 table, we were assigning "ALL" to user_env[1]
                            and user_filename because count = cache_file#.  Since
                            "ALL" is not always a valid option everywhere this is
                            used, this needed to be prevented.  
   Mario B.     98/12/09    See 98/04/09 comments below.  That modification 
                            was inneffective.  I changed it so we actually 
                            count the items in the selection list inside the 
                            GO trigger.  BUG 98-05-27-005.
    McMann      98/07/13    Added _Owner to _File finds
   laurief      98/04/09    Added p_allw and count to allow us to compare
                            the number of tables selected to the total
                            number of tables available.  This needs to be
                            done in the case where a user is not typing "ALL",
                            instead the user types an "*" in the
                            select/deselect dialog.  This allows us to
                            compare count with cache_file# and if they are
                            equal, the .df will contain all database schema
                            info correctly.  BUG 97-07-22-029	
    mcmann      98/02/18    Added initial value * to pattern
    gfs         94/10/31    fix conflict with 'h' hot-key.  
    gfs         94/07/22    fix sellist behavior and add mnemonics to buttons.
    gfs         94/07/21    display correct help on Select/Deselect.
    gfs         94/07/18    display correct titles on Select/Deselect.
    hutegger    94/03/31    modified select-button-trigger so it does NOT
                            deselct already selected tables
                            
----------------------------------------------------------------------------*/

/* This whole file should be used only on GUI, but in case it gets compiled
for TTY mode, let's just turn it into a big empty file */
/*H-*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }
{ adecomm/cbvar.i }
{ prodict/fhidden.i }

/* User_Env input will be tranlated into these logicals. */
Define var p_gotname as logical NO-UNDO.
Define var p_all     as logical NO-UNDO.
Define var p_allw    as logical NO-UNDO.
Define var p_some    as logical NO-UNDO.

/* Form variables */
Define var tprompt  as char    NO-UNDO.
Define var pprompt  as char    NO-UNDO.
Define var tfill    as char    NO-UNDO init "".
Define var tlist    as char    NO-UNDO.
Define var pattern  as char    NO-UNDO initial "*".
Define var thidden  as logical NO-UNDO.

Define button btn_select   label "&Select Some...".
Define button btn_deselect label "&Deselect Some...".

/* Miscellaneous */
Define var chosen as char     	   NO-UNDO.
Define var stat	  as logical       NO-UNDO.
Define var ix	  as integer       NO-UNDO init 0. /* temp looping variable */
Define var msg	  as char extent 1 NO-UNDO init
[
  /* 1 */ "You do not have permission to select tables."
].



/*================================Forms====================================*/
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN

FORM 
   tprompt        at 3 FORMAT "x(32)" view-as TEXT SKIP({&VM_WIDG}) 

   btn_select     at 2    SPACE(1) btn_deselect    SKIP({&VM_WID})
   tfill       	  at row 3 col 3 FORMAT "x(32)"    SKIP({&VM_WID})
   tlist       	  at 3 view-as SELECTION-LIST SINGLE 
      	       	  SIZE 32 by 12 SCROLLBAR-V  	    SKIP({&VM_WID})
   {prodict/user/userbtns.i}
   with frame tbl_get 
      	view-as DIALOG-BOX CENTERED NO-LABELS.

&ELSE
 FORM 
  SKIP({&TFM_WID})
   tprompt        at 2 FORMAT "x(32)" NO-LABEL
      	       	       view-as TEXT    	     	   SKIP({&VM_WIDG}) 
   btn_select     at 2           	     	   SPACE(2)
   btn_deselect    
   tfill       	  at row 3 col 2 FORMAT "x(32)" 
      	       	       {&STDPH_FILL} NO-LABEL
   tlist       	  at 2 view-as SELECTION-LIST SINGLE 
      	       	       INNER-CHARS 32 INNER-LINES 12
      	       	       SCROLLBAR-V SCROLLBAR-H
      	       	       NO-LABEL                    SKIP({&VM_WID})
   thidden     	  at 2 view-as TOGGLE-BOX 
      	       	       LABEL "&Show Hidden"
   {prodict/user/userbtns.i}
   with frame tbl_get 
      	view-as DIALOG-BOX 
        CENTERED DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel.
&ENDIF

FORM 
   SKIP({&TFM_WID})
   pprompt  FORMAT "x(40)" NO-LABEL at 2 view-as TEXT
   "Use '*' and '.' for wildcard patterns.":t45 at 2 view-as TEXT SKIP ({&VM_WIDG})
   pattern  FORMAT "x(50)"   LABEL "Table Name":t17 at 2  {&STDPH_FILL}
   {prodict/user/userbtns.i}
   with frame tbl_patt 
      	view-as DIALOG-BOX TITLE "Select Tables by Pattern Match"
        SIDE-LABELS CENTERED 
        DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel.


/*===============================Triggers==================================*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
/*----- HELP -----*/
on HELP of frame tbl_get OR CHOOSE of btn_Help in frame tbl_get
do: 
   IF p_all then
     RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
         	       	       INPUT {&List_Tables_1orAll_Dlg_Box},
      	       	     	       INPUT ?).
   else if p_some or p_allw then
     RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&List_Tables_Some_Dlg_Box},
      	       	     	     INPUT ?).
   else /* select 1 */
         RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
               	     	           INPUT {&List_Tables_1_Dlg_Box},
      	       	     	           INPUT ?).
end.
   
on HELP of frame tbl_patt OR CHOOSE of btn_Help in frame tbl_patt
DO:
   IF FRAME tbl_patt:TITLE = "Select Tables by Pattern Match" THEN
     RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	       INPUT {&Select_by_Pattern_Dlg_Box},
      	       	     	       INPUT ?).
   ELSE 
     RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	       INPUT {&Deselect_by_Pattern_Dlg_Box},
      	       	     	       INPUT ?).
END.      	       	
&ENDIF

/*----- GO or CHOOSE of OK BUTTON-----*/
on GO of frame tbl_get /* or OK because of auto-go */
do:
   Define var count  as integer       NO-UNDO init 0.
   if tfill:sensitive in frame tbl_get then
      tfill = tfill:screen-value in frame tbl_get.

   if NOT P_all and tfill = "ALL" then
   do:
      message "All is not allowed. Select one table or press Cancel."
      	      view-as alert-box error buttons ok.
     return NO-APPLY.
   end.

   if tlist:screen-value in frame tbl_get = ? AND
      (p_some OR tfill <> "ALL") then
   do:
      message "Select at least one table or press Cancel."
      	      view-as alert-box error buttons ok.
      return NO-APPLY.
   end.
   
   IF tfill               NE "ALL"              AND 
      tfill               NE ""                 AND
      tfill               NE ?                  AND
      tfill               NE tlist:SCREEN-VALUE AND
      tlist:LOOKUP(tfill) EQ 0                  THEN 
   DO:
     MESSAGE "The name typed is not a valid table."
       VIEW-AS ALERT-BOX ERROR BUTTONS OK.
     APPLY "ENTRY" TO tfill IN FRAME tbl_get.
     RETURN NO-APPLY.
   END.
     
   /* Following insures that if user selected "*" during execution of the *
    * btn_select trigger, then changed their minds and deselected some of *
    * tables, they will not get ALL tables anyway.                        */
   DO ix = 1 TO tlist:NUM-ITEMS:
      count = count + INT(tlist:IS-SELECTED(ix)).
   END.  

   assign
      chosen = tlist:screen-value in frame tbl_get
      p_gotname = true.

   if tfill = "ALL" or (count = cache_file# AND (p_some OR p_all)) then
      assign
      	 user_env[1] = "ALL"  
      	 user_filename = "ALL".
   else do:
      user_env[1] = chosen.
      if NUM-ENTRIES(chosen) > 1 then
      	 user_filename = "SOME".
      else
      	 user_filename = chosen.
   end.
end.


/*----- DEFAULT-ACTION of OK SELECT LIST-----*/
on default-action of tlist in frame tbl_get 
   apply "choose" to btn_OK in frame tbl_get.


/*----- CHOOSE of SELECT SOME BUTTON-----*/
on choose of btn_select in frame tbl_get
do:
   Define var choice as char NO-UNDO init "".
   
   ASSIGN FRAME tbl_patt:TITLE = "Select Tables by Pattern Match".
   
   pprompt = "Enter name of table to select.".
   display pprompt with frame tbl_patt.

   assign
     choice = if tlist:screen-value in frame tbl_get <> ?
            then tlist:screen-value in frame tbl_get
            else "".

   do ON ENDKEY UNDO, LEAVE:
      update pattern btn_OK btn_Cancel {&HLP_BTN_NAME} with frame tbl_patt.

      /* Find the list of files that matches the pattern and are
         not selected yet; -> set choice accordingly.
      */
      do ix = 1 to cache_file#:
          if   CAN-DO(pattern, cache_file[ix]) 
       	   AND NOT LOOKUP(cache_file[ix], choice) > 0
             then do: assign choice = choice 
                                + (if choice = "" then "" else ",") 
                                + cache_file[ix].
              end.
      	      	     
      end.

      tlist:screen-value in frame tbl_get = "".
      tlist:screen-value in frame tbl_get = choice.
   end.
end.


/*----- CHOOSE of DESELECT SOME BUTTON-----*/
on choose of btn_deselect in frame tbl_get
do:
   Define var choice as char NO-UNDO init "".
   Define var item   as char NO-UNDO.
   
   ASSIGN FRAME tbl_patt:TITLE = "Deselect Tables by Pattern Match".

   pprompt = "Enter name of table to deselect.".
   display pprompt with frame tbl_patt.

   chosen = tlist:screen-value in frame tbl_get.
   do ON ENDKEY UNDO, LEAVE:
      update pattern btn_OK btn_Cancel {&HLP_BTN_NAME} with frame tbl_patt.

      /* Go through the items already chosen.  Create a new list
      	 without the ones that match the pattern. 
      */
      do ix = 1 to NUM-ENTRIES(chosen):
      	 item = ENTRY(ix, chosen).
      	 if NOT CAN-DO(pattern, item) then
      	    choice = choice + (if choice = "" then "" else ",") + item.
      end.

      /* Must clear choose and then reset to the ones we still want on. */
      tlist:screen-value in frame tbl_get = "". 
      tlist:screen-value in frame tbl_get = choice.
   end.
end.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

/*----- ON VALUE-CHANGED of SHOW-HIDDEN TOGGLE -----*/
ON value-changed of thidden IN frame tbl_get
DO:
   DEFINE VAR tbl     AS CHAR NO-UNDO.
   DEFINE VAR selsave AS CHAR NO-UNDO.
   
   thidden = INPUT frame tbl_get thidden.

   /* Re-fill the list with or without hidden tables. */
   ASSIGN selsave = tlist:SCREEN-VALUE. /* Save off selected items */
   ASSIGN tlist:LIST-ITEMS IN frame tbl_get = "".  /* Clear first */

   run "prodict/_dctcach.p" (thidden).
   do ix = 1 to cache_file#:
      stat = tlist:ADD-LAST(cache_file[ix]) in frame tbl_get.
   end.
   ASSIGN tlist:SCREEN-VALUE = selsave. /* put 'em back */
   IF tlist:SCREEN-VALUE = "" or tlist:SCREEN-VALUE = ? THEN DO:
      tlist:SCREEN-VALUE in frame tbl_get = tlist:ENTRY(1) IN frame tbl_get.
      if tfill:SENSITIVE in frame tbl_get then
         tfill:SCREEN-VALUE in frame tbl_get = tlist:ENTRY(1) in frame tbl_get.
   END.
END.
&ENDIF

/*----- WINDOW-CLOSE of dialog -----*/
on window-close of frame tbl_get
   apply "END-ERROR" to frame tbl_get.
on window-close of frame tbl_patt
   apply "END-ERROR" to frame tbl_patt.



/*============================Mainline code=============================*/

/* Check for read permissions */
find DICTDB._File WHERE DICTDB._File._File-name = "_File"
                    AND DICTDB._File._Owner = "PUB".
if NOT CAN-DO(_Can-read, USERID("DICTDB")) then ix = 1.
if ix > 0 then
do:
   message msg[ix] view-as ALERT-BOX ERROR buttons OK.
   assign
      drec_file     = ?
      user_path     = ""
      user_filename = ""
      user_env[1]   = "".
   return.
end.


if cache_dirty then do:
   /* if current table is schema table, then include them by default */
   find first DICTDB._File 
     where DICTDB._File._Db-recid  = drec_db 
     and   DICTDB._File._File-name = user_filename
     and  (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
     no-lock no-error.
   assign thidden = (available DICTDB._File and DICTDB._File._Hidden = TRUE).
   run "prodict/_dctcach.p" (thidden).
end.
else do: /* determine if cache contains hidden tables */
   assign thidden = false.
   do ix = 1 to cache_file# while NOT thidden:
     find first DICTDB._File 
       where DICTDB._File._Db-recid  = drec_db 
       and   DICTDB._File._File-name = cache_file[ix]
       and  (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
       no-lock no-error.
     assign thidden = (available DICTDB._File and DICTDB._File._Hidden = TRUE).
   end.
end.

ASSIGN
  p_gotname     = user_env[1] MATCHES "*o*" AND drec_file <> ?
  p_all         = user_env[1] MATCHES "*a*"
  p_allw        = user_env[1] MATCHES "***"
  p_some        = user_env[1] MATCHES "*s*".


/* Initialize the prompt and configure the form based on the input */
if p_all then
   /* 1 or ALL */
   assign
      tprompt = "Select a table or type ~"ALL~"."
      btn_select:visible in frame tbl_get = no
      btn_deselect:visible in frame tbl_get = no
      frame tbl_get:title = "Select Tables".
else if p_some then
   /* Some */
   assign
      tprompt = "Select one or more tables."
      tfill:visible in frame tbl_get = no
      tlist:multiple = yes
      tlist:drag-enabled in frame tbl_get = no
      frame tbl_get:title = "Select Tables".
else 
   /* Select 1 */
   assign
      tprompt = "Select a table."
      btn_select:visible in frame tbl_get = no
      btn_deselect:visible in frame tbl_get = no
      frame tbl_get:title = "Select Table".

/* Run time layout for button areas. */
{adecomm/okrun.i  
   &FRAME  = "FRAME tbl_patt" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}
{adecomm/okrun.i  
   &FRAME  = "FRAME tbl_get" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}
tfill:width in frame tbl_get = tlist:width in frame tbl_get.

if NOT p_gotname then
do:
   IF p_all THEN DO:
     IF CACHE_file# > 0 THEN
      ASSIGN stat = tlist:ADD-LAST("ALL") IN FRAME tbl_get.
     do ix = 1 to cache_file#:
       stat = tlist:ADD-LAST(cache_file[ix]) in frame tbl_get.
     end.
   END.
   ELSE do ix = 1 to cache_file#:
      stat = tlist:ADD-LAST(cache_file[ix]) in frame tbl_get.
   end.

   /* Initialize the combo box and initialize the choose based on the 
      last table name chosen. This is only for choose 1 lists. */
   if NOT p_some then
   do:
      if user_filename = "ALL" OR user_filename = "SOME" then
      	 user_filename = "".
      {adecomm/cbdown.i &Frame  = "frame tbl_get"
		     	&CBFill = "tfill"
		     	&CBList = "tlist"
		     	&CBInit = "user_filename"}
   end.
   user_filename = "".
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   display tprompt thidden with frame tbl_get.
    enable btn_select 	when p_some
      	  btn_deselect 	when p_some
      	  tfill	     	when NOT p_some
      	  tlist 
      	  thidden 
      	  btn_OK
      	  btn_Cancel
	  {&HLP_BTN_NAME}
      	  with frame tbl_get.
  &ELSE
   display tprompt with frame tbl_get. 
   enable btn_select 	when p_some
      	  btn_deselect 	when p_some
      	  tfill	     	when NOT p_some
      	  tlist 
          btn_OK
          btn_Cancel
      	  with frame tbl_get.
   &ENDIF
   
  do ON ENDKEY UNDO, LEAVE:
      wait-for GO of frame tbl_get.  /* Or OK - due to auto-go */
   end.
end.

if p_gotname then
do:
   if user_filename = "ALL" OR user_filename = "SOME" then
      drec_file = ?.
   else do:
      FIND FIRST DICTDB._File WHERE DICTDB._File._Db-recid = drec_db AND
               	     	     DICTDB._File._File-name = user_filename AND
                             (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN") 
                             NO-ERROR.
      drec_file = RECID(DICTDB._File).
   end.
end.

SESSION:IMMEDIATE-DISPLAY = yes.
display user_filename WITH FRAME user_ftr.
SESSION:IMMEDIATE-DISPLAY = no.

hide frame tbl_get NO-PAUSE.
if user_filename = "" THEN user_path = "".

 &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ASSIGN thidden
         fhidden = thidden.
 &ENDIF
return.


