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


{as4dict/dictvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{adecomm/cbvar.i shared}
{as4dict/FLD/fldvar.i shared}

Define INPUT PARAMETER p_ReadOnly as logical NO-UNDO.

Define var retval as char NO-UNDO init "". /* return value */

form
   SKIP({&TFM_WID})
   "Expression that must be TRUE for the entered value:"    at  2 
      	       	     view-as TEXT
   SKIP
   b_Field._Valexp   view-as EDITOR SCROLLBAR-VERTICAL
                     SIZE 73 by 3  {&STDPH_ED4GL_SMALL}      at  2  
   SKIP({&VM_WIDG})
   "Field Validation Message:" 	       	     	      	    at  2   
      	       	     view-as TEXT
   SKIP
   b_Field._Valmsg   format "x(72)"  {&STDPH_FILL}           at  2  
   
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


/*----- HELP  not readonly-----*/
on HELP of frame fldvalid OR choose of s_btn_Help in frame fldvalid
    RUN "adecomm/_kwhelp.p" (INPUT b_Field._Valexp:HANDLE,
                             INPUT "as4d",
                             INPUT {&AS4_Field_Validation_Dlg_Box}).   
                             
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

do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO, LEAVE:
   if p_ReadOnly then
   do:
      display b_Field._Valmsg b_Field._Valexp with frame fldvalid.
      color display normal b_Field._Valexp with frame fldvalid.
      update s_btn_Cancel  s_btn_Help with frame fldvalid.
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

      if NOT s_Adding then do:
            {as4dict/setdirty.i &Dirty = "true"}.    
            FIND as4dict.p__File WHERE as4dict.p__file._File-number = b_Field._File-number.
            ASSIGN as4dict.p__File._Fil-Res1[8] = 1
                             as4dict.p__File._Fil-Misc1[1] = as4dict.p__File._Fil-Misc1[1] + 1.      
            IF as4dict.p__File._Fil-res1[7] < 0 then assign as4dict.p__File._Fil-res1[7] = 0.                 
      end.        	 
      retval = "mod".
   end.
end.

hide frame fldvalid.
return retval.
