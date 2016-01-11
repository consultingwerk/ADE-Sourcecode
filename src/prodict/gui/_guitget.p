/*********************************************************************
* Copyright (C) 2007,2009,2011,2013 by Progress Software Corporation.*
*  All rights reserved.  Prior versions of this work may contain     *
* portions contributed by participants of Possenet.                  *
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
      of filenames.  Or it may be in user_longchar, if list was too big.
      If a comma-sep list is returned in user_env[1], 'SOME'
      is returned in user_filename.
 
Author: Laura Stern

Date Created: 11/16/92 

History
   McIntosh K.  02/15/05    Added "Show Hidden" toggle on TTY - 20050104-024.
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
    fernando    03/13/06    Using temp-table to store table names - bug 20050930-006.
    fernando    12/13/07    Handle long list of selected tables
    fernando    08/04/09    fixed select some for temp-table case
                            
----------------------------------------------------------------------------*/

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
DEFINE VARIABLE tblslcn AS CHARACTER   INITIAL "A" NO-UNDO.
DEFINE VAR ismultitenant     AS LOGICAL NO-UNDO INIT FALSE.
DEFINE VAR issupertenant     AS LOGICAL NO-UNDO INIT FALSE.

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

DEFINE VAR message_displayed AS LOGICAL NO-UNDO INIT NO.
DEFINE VAR cLongSize         AS INTEGER NO-UNDO.
DEFINE VAR numCount          AS INTEGER NO-UNDO.

DEFINE VARIABLE isCpUndefined AS LOGICAL NO-UNDO.

/*================================Forms====================================*/
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN

FORM 
   tprompt        at 3 FORMAT "x(32)" view-as TEXT SKIP({&VM_WIDG}) 

   btn_select     at 2    SPACE(1) btn_deselect    SKIP({&VM_WID})
   tfill       	  at row 3 col 3 FORMAT "x(32)"    SKIP({&VM_WID})
   tlist       	  at 3 view-as SELECTION-LIST   SINGLE  
      	       	  SIZE 32 by 10 SCROLLBAR-V  	    SKIP({&VM_WID})
   tblslcn        at 2 VIEW-AS RADIO-SET RADIO-BUTTONS "All", "A",
                                               "Multi-tenant", "MT",
                                               "Shared", "SH"
                                 HORIZONTAL NO-LABEL  SKIP({&VM_WID})
   thidden        at 2 view-as TOGGLE-BOX
                       LABEL "&Show Hidden"
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
   tlist       	  at 2 view-as SELECTION-LIST   SINGLE 
      	       	       INNER-CHARS 32 INNER-LINES 10
      	       	       SCROLLBAR-V SCROLLBAR-H
      	       	       NO-LABEL                    SKIP({&VM_WID})
   tblslcn          at 2 VIEW-AS RADIO-SET RADIO-BUTTONS "All", "A",
                                               "Multi-tenant", "MT",
                                               "Shared", "SH"
                                 HORIZONTAL NO-LABEL  SKIP({&VM_WID})
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

   if tfill = "ALL" or (count = cache_file# AND (p_some OR p_all)) OR
      (l_cache_tt AND chosen = "*ALL*") then
      assign
      	 user_env[1] = "ALL"  
      	 user_filename = "ALL"
         user_longchar = (IF isCpUndefined THEN user_longchar ELSE "").
   else do:
      user_env[1] = chosen NO-ERROR.
      /* if we couldn't add it to user_env[1], try the longchar in case
         string is too big .
      */
      IF NOT ERROR-STATUS:ERROR THEN
         ASSIGN user_longchar = (IF isCpUndefined THEN user_longchar ELSE "").
      ELSE DO:
         /* if undefined codepage, then there is nothing we can do but
            error out
         */
         IF isCpUndefined THEN DO:
            MESSAGE ERROR-STATUS:GET-MESSAGE(1)
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN NO-APPLY.
         END.

         ASSIGN user_env[1] = ""
                user_longchar = chosen.
      END.

      if NUM-ENTRIES(chosen) > 1 THEN
      	 assign user_filename = "SOME".
      else
      	 assign user_filename = chosen.
   end.
   
end.


/*----- DEFAULT-ACTION of OK SELECT LIST-----*/
on default-action of tlist in frame tbl_get 
   apply "choose" to btn_OK in frame tbl_get.

/*------ MOUSE-SELECT-CLICK of SELECT LIST----*/
ON VALUE-CHANGED OF tlist IN FRAME tbl_get 
DO:

   DEFINE VARIABLE choice AS CHAR NO-UNDO.

   /* make sure that ALL is not selected when other tables are selected.
      This is only the case when we have too many tables in the list (l_cache_tt
      will be set).
   */
   IF l_cache_tt AND p_some THEN DO:
      IF SUBSTRING(tlist:screen-value,1,6) = "*ALL*," THEN DO:
         ASSIGN tlist:screen-value = ""
                tlist:screen-value = "*ALL*".
      END.

   END.
END.

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

      IF l_cache_tt AND (TRIM(pattern) = "*" OR TRIM(pattern) = "ALL") THEN
         ASSIGN choice = "*ALL*".
      else do:

         /* if they selected ALL and now are trying to select something else, 
             get rid of all 
         */

         IF l_cache_tt AND choice = "*ALL*" THEN
            ASSIGN choice = "".
         
         IF l_cache_tt THEN DO:
             /* look for tables in the temp-table */
          
            FOR EACH tt_cache_file NO-LOCK:              
                 if CAN-DO(pattern, tt_cache_file.cName) 
                 AND NOT LOOKUP( tt_cache_file.cName, choice) > 0 THEN 
                 DO:
                     IF choice = "" THEN
                         ASSIGN choice = tt_cache_file.cName.
                     ELSE DO:
                         ASSIGN choice = choice + "," + tt_cache_file.cName NO-ERROR.
                         IF ERROR-STATUS:ERROR THEN 
                         DO:
                            MESSAGE  "Too many tables selected. Not all tables were selected due to error:"
                                     SKIP ERROR-STATUS:GET-MESSAGE(1)
                                     VIEW-AS ALERT-BOX ERROR.
                            LEAVE.
                         END.
                     END.   
                 END.
            END.
         END.
         ELSE do ix = 1 to cache_file#:
           if   CAN-DO(pattern, cache_file[ix]) 
       	   AND NOT LOOKUP(cache_file[ix], choice) > 0 then 
       	   do:
             FIND DICTDB._File where DICTDB._File._File-name EQ cache_file[ix]
                                 and (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN").
             
             if  tblslcn:SCREEN-VALUE in frame tbl_get = "A"  THEN DO:
                /* the assign below used to be one statement, but I separated it
                   in two to handle selecting lots of tables so we don't run
                   out of stack space.
                */
                IF choice = "" THEN
                    ASSIGN choice = cache_file[ix].
                ELSE DO:
                    ASSIGN choice = choice + "," + cache_file[ix] NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN 
                    DO:
                       MESSAGE  "Too many tables selected. Not all tables were selected due to error:"
                                SKIP ERROR-STATUS:GET-MESSAGE(1)
                                VIEW-AS ALERT-BOX ERROR.
                       LEAVE.
                    END.
                END.
             END.

              if  tblslcn:SCREEN-VALUE in frame tbl_get = "MT"  THEN DO:
                /* the assign below used to be one statement, but I separated it
                   in two to handle selecting lots of tables so we don't run
                   out of stack space.
                */
               if DICTDB._File._File-attributes[1] EQ TRUE THEN DO:
                IF choice = "" THEN
                    ASSIGN choice = cache_file[ix].
                ELSE DO:
                    ASSIGN choice = choice + "," + cache_file[ix] NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN 
                    DO:
                       MESSAGE  "Too many tables selected. Not all tables were selected due to error:"
                                SKIP ERROR-STATUS:GET-MESSAGE(1)
                                VIEW-AS ALERT-BOX ERROR.
                       LEAVE.
                    END.
                END.
             END.
            END.

              if  tblslcn:SCREEN-VALUE in frame tbl_get = "SH"  THEN DO:
                /* the assign below used to be one statement, but I separated it
                   in two to handle selecting lots of tables so we don't run
                   out of stack space.
                */
               if DICTDB._File._File-attributes[1] NE TRUE THEN DO:
                IF choice = "" THEN
                    ASSIGN choice = cache_file[ix].
                ELSE DO:
                    ASSIGN choice = choice + "," + cache_file[ix] NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN 
                    DO:
                       MESSAGE  "Too many tables selected. Not all tables were selected due to error:"
                                SKIP ERROR-STATUS:GET-MESSAGE(1)
                                VIEW-AS ALERT-BOX ERROR.
                       LEAVE.
                    END.
                END.
             END.
            END.

           end.
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

   do ON ENDKEY UNDO, LEAVE:
      update pattern btn_OK btn_Cancel {&HLP_BTN_NAME} with frame tbl_patt.

         chosen = tlist:screen-value in frame tbl_get.

         do ix = 1 to NUM-ENTRIES(chosen):
      	     item = ENTRY(ix, chosen).
      	     if NOT CAN-DO(pattern, item) then
      	        choice = choice + "," + item.
         end.
         choice = LEFT-TRIM(choice,",").
      /* Must clear choose and then reset to the ones we still want on. */
      tlist:screen-value in frame tbl_get = "". 
      tlist:screen-value in frame tbl_get = choice.
   end.
end.

/*----- ON VALUE-CHANGED of SHOW-HIDDEN TOGGLE -----*/
ON value-changed of thidden IN frame tbl_get
DO:
   DEFINE VAR tbl     AS CHAR NO-UNDO.
   DEFINE VAR selsave AS CHAR NO-UNDO.
   
   thidden = INPUT frame tbl_get thidden.

   run "prodict/_dctcach.p" (thidden).
   run BuildList(INPUT tblslcn:SCREEN-VALUE in frame tbl_get).

END.


/*----- ON VALUE-CHANGED of all, MT or shared radio-set -----*/
ON VALUE-CHANGED OF tblslcn IN FRAME tbl_get DO:
   run BuildList(INPUT tblslcn:SCREEN-VALUE  in frame tbl_get).
END. 

/*----- WINDOW-CLOSE of dialog -----*/
on window-close of frame tbl_get
   apply "END-ERROR" to frame tbl_get.
on window-close of frame tbl_patt
   apply "END-ERROR" to frame tbl_patt.



/*============================Mainline code=============================*/

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN

IF SESSION:CPINTERNAL EQ "undefined":U THEN
    isCpUndefined = YES.

&ENDIF
 
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
      user_env[1]   = ""
      user_longchar = (IF isCpUndefined THEN user_longchar ELSE "").
   return.
end.

ismultitenant = can-find(first DICTDB._tenant ). /* Is DB multitenant */
if ismultitenant then 
     assign issupertenant = can-find(first dictdb._tenant) and  tenant-id("dictdb") < 0.
else
    issupertenant = no.

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

   /* 20050930-006 - check if we cached the table names in the temp-table */
   IF l_cache_tt THEN DO:

      FOR EACH tt_cache_file NO-LOCK:
         find first DICTDB._File 
           where DICTDB._File._Db-recid  = drec_db 
           and   DICTDB._File._File-name = tt_cache_file.cName
           and  (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN")
           no-lock no-error.
         assign thidden = (available DICTDB._File and DICTDB._File._Hidden = TRUE).

         IF thidden THEN 
            LEAVE. /* that's it */
      END.
   END.
   ELSE do ix = 1 to cache_file# while NOT thidden:
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

/* clear it out */
IF NOT isCpUndefined THEN
   assign user_longchar = "".
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

if ismultitenant and issupertenant THEN 
       tblslcn:visible in frame tbl_get = TRUE.
else
       ASSIGN tblslcn:visible in frame tbl_get = FALSE
              tblslcn:screen-value in frame tbl_get = "A".

if NOT p_gotname then
do:
   IF p_all THEN DO:
     IF CACHE_file# > 0 THEN
      ASSIGN stat = tlist:ADD-LAST("ALL") IN FRAME tbl_get.
   END.

   /* 20050930-006 - check if we are caching the table names in the temp-table */
   IF l_cache_tt THEN DO:
       IF p_some THEN
         stat =  tlist:ADD-LAST("*ALL*") in frame tbl_get.

       FOR EACH tt_cache_file NO-LOCK:
          stat = tlist:ADD-LAST(tt_cache_file.cName) in frame tbl_get.
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
          tblslcn       WHEN ismultitenant and issupertenant
      	  thidden 
      	  btn_OK
      	  btn_Cancel
	  {&HLP_BTN_NAME}
      	  with frame tbl_get.
  &ELSE
   display tprompt thidden with frame tbl_get. 
   enable btn_select 	when p_some
      	  btn_deselect 	when p_some
      	  tfill	     	when NOT p_some
      	  tlist 
          tblslcn       WHEN ismultitenant and issupertenant
          thidden
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

  ASSIGN thidden
         fhidden = thidden.
return.



PROCEDURE BuildList:
    DEFINE INPUT PARAMETER ttype AS CHARACTER NO-UNDO.
    DEFINE VAR selsave AS CHAR NO-UNDO.

    ASSIGN selsave = tlist:SCREEN-VALUE in frame tbl_get.  /* Save off selected items */
    ASSIGN tlist:LIST-ITEMS IN frame tbl_get = "".  /* Clear first */

   IF l_cache_tt THEN DO:
       IF p_some THEN
         stat =  tlist:ADD-LAST("*ALL*") in frame tbl_get.

    IF ttype = "A" THEN 
       FOR EACH tt_cache_file NO-LOCK:
          stat = tlist:ADD-LAST(tt_cache_file.cName) in frame tbl_get.
       end.

    ELSE IF ttype = "MT" THEN 
       FOR EACH tt_cache_file NO-LOCK where  tt_cache_file.multitenant = TRUE:
          stat = tlist:ADD-LAST(tt_cache_file.cName) in frame tbl_get.
       end.


    ELSE IF ttype = "SH" THEN 
       FOR EACH tt_cache_file NO-LOCK where  tt_cache_file.multitenant NE TRUE:
          stat = tlist:ADD-LAST(tt_cache_file.cName) in frame tbl_get.
       end.
   end.
   ELSE
     do ix = 1 to cache_file#:
     FIND DICTDB._File where DICTDB._File._File-name EQ cache_file[ix] and (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN").

       if  ttype = "A"  THEN DO:
           stat = tlist:ADD-LAST(cache_file[ix]) in frame tbl_get.
       END.
       if  ttype = "MT"  THEN DO:
         if DICTDB._File._File-attributes[1] EQ TRUE THEN 
           stat = tlist:ADD-LAST(cache_file[ix]) in frame tbl_get.
       END.
       else if ttype = "SH"  THEN DO:
         if DICTDB._File._File-attributes[1] NE TRUE THEN 
           stat = tlist:ADD-LAST(cache_file[ix]) in frame tbl_get.
       END.
   end.

    ASSIGN tlist:SCREEN-VALUE = selsave.  /* put 'em back */
   
END PROCEDURE.

