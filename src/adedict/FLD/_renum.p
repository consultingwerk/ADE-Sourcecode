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

File: _renum.p

Description:
   Display and handle the field renumber dialog box to renumber all
   the field order numbers for a table.

Author: Laura Stern

Date Created: 03/23/92 
    Modified: D. McMann Added _Owner to find of _File
      	      Mario B. 11/17/98 Changed renumbering from using a fixed offset
	                        of - 10000 for pre-conversion to using * -1 to
				prevent conflicts when a 10000+ Order# exists.
              D. McMann 06/10/02 Added check for session schema change attribute

----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}

Define var NumFlds   	      as integer NO-UNDO init 0.
Define var Fld_Renum_Start    as integer NO-UNDO.
Define var Fld_Renum_Incr     as integer NO-UNDO.
Define var Fld_Order          as char    NO-UNDO format "x(16)".

Define var Overflow_Msg1      as char  NO-UNDO
   init "The highest allowed _Order value is 99999.".
Define var Overflow_Msg2      as char  NO-UNDO
   init "These values will cause _Order to overflow.".

Define buffer x_File for _File.

form
   SKIP({&TFM_WID})
   "The current field order setting determines the order in which":t65  VIEW-AS TEXT AT 2 
   SKIP
   "fields are read for renumbering.":t65  VIEW-AS TEXT at 2
   SKIP({&VM_WIDG})

   Fld_Renum_Start   label "&Start Numbering From"    colon 28
      	       	     format ">>,>>>" {&STDPH_FILL}
   SKIP({&VM_WID})

   Fld_Renum_Incr    label "&Increment Each by"	      colon 28
      	       	     format ">>,>>>" {&STDPH_FILL} 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}

   with frame fld_renum
        view-as DIALOG-BOX
        TITLE "Renumber Fields in Table " + x_file._File-Name
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        SIDE-LABELS.


/*-------------------------------Triggers------------------------------------*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame fld_renum
   apply "END-ERROR" to frame fld_renum.


/*----- HIT of OK BUTTON OR GO -----*/
on GO of frame fld_renum   /* OR OK due to AUTO-GO */
do:
   Define var start   	as integer NO-UNDO.
   Define var incr    	as integer NO-UNDO. 
   Define var nextnum 	as integer NO-UNDO.
   Define var orignum   as integer NO-UNDO.

   /* Status frame */
   FORM
      SKIP(1)
      SPACE(3) orignum  LABEL "Changing" format ">>>>9"
      	       nextnum  LABEL "To"       format ">>>>9"
      SPACE(3)
      SKIP(1)
      with frame stat SIDE-LABELS view-as dialog-box.

   start = input frame fld_renum Fld_Renum_Start.
   incr = input frame fld_renum Fld_Renum_Incr.
   
   if start + incr * (NumFlds - 1) > 99999 then
   do:
      message Overflow_Msg1 SKIP Overflow_Msg2
      	      view-as ALERT-BOX ERROR
      	      buttons OK.
      return NO-APPLY.
   end.

   /* Let's do it. */
   nextnum = start.

   do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
      run adecomm/_setcurs.p (INPUT "WAIT").

      /* We have to make sure that the new numbers don't conflict with any
      	 existing numbers.  
      */
      for each _Field of x_File:
      	 _Field._Order = _Field._Order * -1.
      end.

      session:immediate-display = yes.

      if s_Order_By = {&ORDER_ALPHA} then
	 for each _Field of x_File by _Field._Field-Name:
      	    display _Field._Order * -1 @ orignum nextnum with frame stat.
	    _Field._Order = nextnum.
	    nextnum = nextnum + incr.
	 end.
      else
	 for each _Field of x_File by _Field._Order DESCENDING:
      	    display _Field._Order * -1 @ orignum  nextnum with frame stat.
	    _Field._Order = nextnum.
	    nextnum = nextnum + incr.
	 end.
      
      hide frame stat no-pause.
      session:immediate-display = no.

      /* Refresh any current display to reflect this change. We don't have
      	 to redisplay the field list, since if fields are displayed by
      	 order, they are renumbered in that same order anyway. */
      if s_win_Fld <> ? then
      do:
      	 find _Field of x_File where _Field._Field-Name = s_CurrFld.
      	 b_Field._Order = _Field._Order.
      	 display b_Field._Order with frame fldprops.
      end.
      
      {adedict/setdirty.i &Dirty = "true"}
      run adecomm/_setcurs.p (INPUT "").
      return.
   end.

   /* Get here only if error - leave dialog box up and let user hit cancel */
   run adecomm/_setcurs.p (INPUT "").
   return NO-APPLY.	 
end.


/*----- LEAVE of RENUM-INCR ----- */
on leave of Fld_Renum_Incr in frame fld_renum
do:
   Define var incr as integer NO-UNDO.

   incr = INTEGER(SELF:screen-value).

   if incr <= 0 OR incr = ? then 
   do:	 
      message "Please enter a positive number to increment by."
      	      view-as ALERT-BOX ERROR buttons OK.
      return NO-APPLY.
   end.
end.


/*----- HELP -----*/
on HELP of frame fld_renum OR choose of s_btn_Help in frame fld_renum
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", 
      	       	     	     {&Renumber_Order_Numbers_Dlg_Box}, ?).


/*----------------------------Mainline code----------------------------------*/

Define var msg_text as char NO-UNDO.


find _File WHERE _File._File-name = "_Field"
             AND _File._Owner = "PUB".
if NOT can-do(_File._Can-write, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "modify fields."
      view-as ALERT-BOX ERROR buttons Ok.
   return.
end.

/* Check some other conditions */
msg_text = "".
find x_File where x_File._File-Name = s_CurrTbl AND
     x_File._DB-recid = s_DbRecId AND
     (x_File._Owner = "PUB" OR x_File._Owner = "_FOREIGN").

/* The _numfld field is only updated at commit time so if dict is 
   dirty - count the number the slow way.
*/
if NOT s_DictDirty then
   NumFlds = x_File._numfld - 1.  
else
   for each _Field of x_File:
      NumFlds = NumFlds + 1.
   end.

if x_File._Db-lang >= {&TBLTYP_SQL} then
   msg_text = "You cannot change the order of PROGRESS/SQL fields.".

if msg_text = "" then
   if x_File._Frozen then 
      msg_text = "The definitions for this table have been frozen.".

if msg_text = "" then
   if NumFlds = 0 then
      msg_text = "There are no fields in this table to be renumbered.".

&IF PROVERSION >= "9.1E" &THEN
    IF SESSION:SCHEMA-CHANGE = "New Objects" THEN
      ASSIGN msg_text = 'You can not renumber fields when SESSION:SCHEMA-CHANGE = "New Objects".'.
&ENDIF

if msg_text <> "" then
do:
   message msg_text view-as ALERT-BOX ERROR buttons OK.
   return.
end.   

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame fld_renum" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

Fld_Renum_Start = 10.
Fld_Renum_Incr = 10.
Fld_Order = (if s_Order_By = {&ORDER_ALPHA} then "alphabetical"
      	       	     	      	       	    else "by order number").
/*display Fld_Order with frame fld_renum.*/

do ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   update Fld_Renum_Start  
      	  Fld_Renum_Incr
       	  s_btn_Ok         
      	  s_btn_Cancel
      	  s_btn_Help
      with frame fld_renum.

   /* OK Processing is done in trigger */
end.

hide frame fld_renum.
return.





