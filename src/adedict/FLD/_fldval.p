/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _fldval.p

Description:   
   Display and handle the field validation dialog box.

Input Parameter:
   p_ReadOnly - The read only flag to check (could be for flds or domains).

Returns: "mod" if user OK'ed changes (though we really don't
      	 check to see if the values actually are different),
      	 "" if user Cancels.

Author: Laura Stern

Date Created: 02/17/92 

Modified on 07/08/94 by gfs - Fixed bug 94-06-14-073.

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}

Define INPUT PARAMETER p_ReadOnly as logical NO-UNDO.

Define var retval as char NO-UNDO init "". /* return value */

form
   SKIP({&TFM_WID})
   "Expression that must be TRUE for the entered value:"    at  2 
      	       	     view-as TEXT
   SKIP
   b_Field._Valexp   view-as EDITOR SCROLLBAR-VERTICAL
                     SIZE 73 by 3 {&STDPH_ED4GL_SMALL}      at  2  
   SKIP({&VM_WIDG})
   "Field Validation Message:" 	       	     	      	    at  2   
      	       	     view-as TEXT
   SKIP
   b_Field._Valmsg   format "x(72)" {&STDPH_FILL}           at  2  
   
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = s_btn_OK
      &CANCEL = s_btn_Cancel
      &HELP   = s_btn_Help}
   
   with frame fldvalid
        NO-LABELS 
        DEFAULT-BUTTON s_btn_OK CANCEL-BUTTON s_btn_Cancel
        view-as DIALOG-BOX TITLE "Field Validation".


/*------------------------------Trigger Code---------------------------------*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame fldvalid
   apply "END-ERROR" to frame fldvalid.


/*----- SELECTION of OK BUTTON -----*/
on GO of frame fldvalid	/* or OK because of AUTO-GO */
do:
   Define var msg  as char NO-UNDO.
   Define var expr as char NO-UNDO.

   assign
      msg = TRIM(input frame fldvalid b_Field._Valmsg)
      expr = TRIM(input frame fldvalid b_Field._Valexp).


   if NOT (msg = "" OR msg = ?) then 
   do:  /* message is not blank */
      if expr = "" OR expr = ? then    
      do:
      	 message "Please enter a validation expression to" SKIP
      	       	 "go along with your validation message."
      	       	 view-as ALERT-BOX ERROR buttons OK.
      	 apply "entry" to b_Field._Valexp in frame fldvalid.
      	 return NO-APPLY.
      end.
   end.
   else  /* message is blank */ 
      if NOT (expr = "" OR expr = ?) then 
      do:
	 message "Please enter a validation message to" SKIP
		  "go along with your validation expression."
		  view-as ALERT-BOX ERROR buttons OK.
	 apply "entry" to b_Field._Valexp in frame fldvalid.
	 return NO-APPLY.
      end.
end.


/*----- HELP -----*/
on HELP of frame fldvalid OR choose of s_btn_Help in frame fldvalid
    RUN "adecomm/_kwhelp.p" (INPUT b_Field._Valexp:HANDLE,
                             INPUT "dict",
                             INPUT {&Field_Validation_Dlg_Box}).

/*------------------------------Mainline Code--------------------------------*/

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame fldvalid" 
   &BOX   = "s_rect_Btns"
   &OK    = "s_btn_OK" 
   &HELP  = "s_btn_Help"
}

/* So Return doesn't hit default button in editor widget */
b_Field._Valexp:RETURN-INSERT = yes.

display b_Field._Valmsg b_Field._Valexp with frame fldvalid.

do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO, LEAVE:
   if p_ReadOnly then
   do:
      display b_Field._Valmsg b_Field._Valexp with frame fldvalid.
      update s_btn_Cancel with frame fldvalid.
   end.
   else do:
      update b_Field._Valexp  
      	     b_Field._Valmsg
      	     s_btn_Ok  	      
      	     s_btn_Cancel
      	     s_btn_Help
      	     with frame fldvalid.

      /* Remove any line feeds (which we get on WINDOWS) and remove
      	 extraneous spaces and carriage returns. */
      b_Field._Valexp = TRIM(replace (b_Field._Valexp, CHR(13), "")).

      if NOT s_Adding then
      	 {adedict/setdirty.i &Dirty = "true"}.
      retval = "mod".
   end.
end.

hide frame fldvalid.
return retval.
