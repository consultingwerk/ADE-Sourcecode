/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/*----------------------------------------------------------------------------

File: _guivget.p
 
Description: Select a view.

INPUT:
   user_env[1] MATCHES "*a*":
   If this program sees an "a" (for "all"), then "ALL" is a valid choice.
   
OUTPUT:
   user_env[1] contains the view name selected, or 'ALL'.

Last Modified on 10/31/94 by GFS - disallow bad view name entered
                  07/14/98 by DLM - Added _Owner to _file finds

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE NOTTCACHE 1

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ adecomm/cbvar.i }

/* Form variables */
Define var vprompt as char     NO-UNDO.
Define var vfill    as char    NO-UNDO.
Define var vlist    as char    NO-UNDO.

/* Miscelaneous */
Define var p_all  as logical NO-UNDO.
Define var stat	  as logical       NO-UNDO.
Define var ix	  as integer       NO-UNDO init 0. /* temp looping variable */
Define var access as logical       NO-UNDO.
Define var msg	  as char extent 2 NO-UNDO init
[
  /* 1 */ "You do not have permission to select views.",
  /* 2 */ "There are no views in this database to select."
].


/*================================Forms====================================*/

/* I couldn't get this to work really well under both enviroments so
   here's two slightly different frame layouts.
*/
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
FORM 
   vprompt    at 3 FORMAT "x(32)" view-as TEXT	 SKIP(1) 

   vfill      at 3 FORMAT "x(32)"  SKIP
   vlist      at 3 
      	      view-as SELECTION-LIST SINGLE 
      	      SIZE 32 by 12 SCROLLBAR-V     	 SKIP(1)
   {prodict/user/userbtns.i}
   with frame view_get 
      	view-as DIALOG-BOX title "Select Views"
        CENTERED NO-LABELS
        DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel.
&ELSE
FORM 
   SKIP({&TFM_WID})
   vprompt    at 3 FORMAT "x(32)" view-as TEXT 	 SKIP({&VM_WID}) 

   vfill      at 3 FORMAT "x(32)"  {&STDPH_FILL} SKIP
   vlist      at 3 
      	      view-as SELECTION-LIST SINGLE 
      	      INNER-CHARS 32 INNER-LINES 12 
      	      SCROLLBAR-V
   {prodict/user/userbtns.i}
   with frame view_get 
      	view-as DIALOG-BOX title "Select Views"
        CENTERED NO-LABELS 
        DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel.
&ENDIF

/*===============================Triggers==================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame view_get
   or CHOOSE of btn_Help in frame view_get
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&List_Views_Dlg_Box},
      	       	     	     INPUT ?).
&ENDIF


/*----- GO OR CHOOSE of OK BUTTON-----*/
on GO of frame view_get    /* or OK due to auto-go */
do:
   vfill = vfill:screen-value in frame view_get.

   if NOT (vfill = "ALL" AND p_all) AND
      vlist:LOOKUP(vfill) = 0 then
   do:	 
      message "The name entered does not match" SKIP
      	      "any view name in this database."
      	      view-as ALERT-BOX ERROR buttons OK.
      apply "entry" to vfill in frame view_get.
      return NO-APPLY.
   end.

   user_env[1] = vfill.
end.


/*----- DEFAULT-ACTION of OK SELECT LIST-----*/
on default-action of vlist in frame view_get 
   apply "choose" to btn_OK in frame view_get.

ON WINDOW-CLOSE OF FRAME view_get
   APPLY "END-ERROR" TO FRAME view_get.

/*==============================Mainline code=============================*/

DEFINE VARIABLE l AS LOGICAL NO-UNDO.

if NOT CAN-FIND(FIRST DICTDB._View) then
   ix = 2. /* there are no views */

do for DICTDB._File:
   find _File "_View" WHERE _File._Owner = "PUB" NO-LOCK.
   access = CAN-DO(_Can-read,USERID("DICTDB")).
   if access then
   do:
      find _File "_View-ref" WHERE _File._Owner = "PUB" NO-LOCK.
      access = CAN-DO(_Can-read,USERID("DICTDB")).
   end.
   if access then
   do:
      find _File "_View-col" WHERE _File._Owner = "PUB" NO-LOCK.
      access = CAN-DO(_Can-read,USERID("DICTDB")).
   end.
   if NOT access THEN ix = 1. /* You're not supposed to see any views */
end.

IF ix > 0 then
do:
  message msg[ix] view-as ALERT-BOX ERROR buttons OK.
  assign
    user_path   = ""
    user_env[1] = "".
  return.
END.

/* Adjust the graphical rectangle and the ok and cancel buttons */
{adecomm/okrun.i  
   &FRAME  = "FRAME view_get" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}
p_all = (if user_env[1] MATCHES "*a*" then yes else no).
if p_all then
   vprompt = "Select a view or type ~"ALL~".".
else
   vprompt = "Select a view.".

for each DICTDB._View:
   stat = vlist:add-last(DICTDB._View._View-name) in frame view_get.
end.

{adecomm/cbdown.i &Frame  = "frame view_get"
		  &CBFill = "vfill"
		  &CBList = "vlist"
		  &CBInit = """"}

display vprompt with frame view_get.
enable  vfill	 
      	vlist 
   	btn_OK
   	btn_Cancel
        {&HLP_BTN_NAME}
   	with frame view_get.

user_status = "Press the" + " [" + KBLABEL("END-ERROR") + "] " + "key to end.".
STATUS DEFAULT user_status.

user_env[1] = "".
do ON ENDKEY UNDO, LEAVE:
   wait-for GO of frame view_get.   /* or OK - due to auto-go */
end.

user_status = ?.
STATUS DEFAULT.

IF user_env[1] = "" THEN user_path = "".
hide frame view_get no-pause.
return.



