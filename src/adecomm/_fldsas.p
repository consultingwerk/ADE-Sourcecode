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

File: fldsas.p  (field string attributes dialog box)
      	        *** Used for both GUI and Character Dictionaries ***

Description:   
   Display and handle the dialog box for specifying string attributes
   this field.

Input Parameter:
   p_ReadOnly  - True if box should be non-modifiable.
   p_Buf       - The database field buffer we're working on

Output Parameter:
   p_Modified  - Set to yes if a modification was made, no otherwise.

Author: Laura Stern

Date Created: 04/02/93 

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/commeng.i}
{adecomm/adestds.i}

Define button btn_Ok     label "OK"     {&STDPH_OKBTN} AUTO-GO.
Define button btn_Cancel label "Cancel" {&STDPH_OKBTN} AUTO-ENDKEY.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
   Define rectangle rect_Btns {&STDPH_OKBOX}.
   Define button    btn_Help label "&Help" {&STDPH_OKBTN}.

   &GLOBAL-DEFINE   HLP_BTN  &HELP = "btn_Help"
   &GLOBAL-DEFINE   CAN_BTN  /* we have one but it's not passed to okrun.i */
   &GLOBAL-DEFINE   RECT     &BOX = "rect_btns"
&ELSE
   &GLOBAL-DEFINE   HLP_BTN  /* no help for tty */
   &GLOBAL-DEFINE   CAN_BTN  &CANCEL = "btn_Cancel" /* so btn can be centered */
   &GLOBAL-DEFINE   RECT   
&ENDIF

Define INPUT  PARAMETER p_ReadOnly     as logical NO-UNDO.
Define 	      PARAMETER BUFFER  p_Buf  for _Field.
Define OUTPUT PARAMETER p_Modified     as logical NO-UNDO init no.

FORM
   SKIP({&TFM_WID})
   "String attribute options are:"      at 2 view-as TEXT SKIP
   "T, R, L, C, U and # of characters." at 2 view-as TEXT 
   SKIP({&VM_WIDG})

   p_Buf._Label-SA 	colon 21 label "&Label"      	 {&STDPH_FILL}
   SKIP({&VM_WID})

   p_Buf._Col-label-SA  colon 21 label "&Column Label" 	 {&STDPH_FILL}
   SKIP({&VM_WID})

   p_Buf._Format-SA	colon 21 label "&Format"     	 {&STDPH_FILL}
   SKIP({&VM_WID})

   p_Buf._Initial-SA	colon 21 label "&Initial Value"  {&STDPH_FILL}
   SKIP({&VM_WID})

   p_Buf._Help-SA	colon 21 label "Hel&p"     	 {&STDPH_FILL}
   SKIP({&VM_WID})

   p_Buf._Valmsg-SA	colon 21 label "&Validation Message" {&STDPH_FILL}

   {adecomm/okform.i
      {&RECT}
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      {&HLP_BTN}
   }

   with frame fld_string_attrs
   SIDE-LABELS 
   DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   view-as DIALOG-BOX TITLE "Field String Attributes".


/*--------------------------------Triggers-----------------------------------*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame fld_string_attrs OR 
   choose of btn_Help in frame fld_string_attrs
   RUN "adecomm/_adehelp.p" (INPUT "comm", INPUT "CONTEXT", 
      	       	     	     INPUT {&Field_String_Attributes_Dlg_Box},
      	       	     	     INPUT ?).
&ENDIF


/*-----WINDOW-CLOSE-----*/
on window-close of frame fld_string_attrs
   apply "END-ERROR" to frame fld_string_attrs.


/*---- GO or OK -----*/
on GO of frame fld_string_attrs
do:
   DO ON ERROR UNDO, LEAVE:
      assign 
	 p_Buf._Label-SA
	 p_Buf._Valmsg-SA
      	 p_Buf._Col-label-SA
      	 p_Buf._Format-SA
      	 p_Buf._Initial-SA
      	 p_Buf._Help-SA.
      return.
   END.

   /* error occurred */
   apply "entry" to p_Buf._Label-SA in frame fld_string_attrs.
   return no-apply.  
end.


/*------------------------------Mainline Code--------------------------------*/

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame fld_string_attrs" 
   &BOX   = "rect_Btns"
   &OK    = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}

display (if p_Buf._Label-SA = ? then "" else p_Buf._Label-SA)
      	    @ p_Buf._Label-SA
      	(if p_Buf._Col-label-SA = ? then "" else p_Buf._Col-label-SA)
      	    @ p_Buf._Col-label-SA
      	(if p_Buf._Format-SA = ? then "" else p_Buf._Format-SA)
      	    @ p_Buf._Format-SA
      	(if p_Buf._Initial-SA = ? then "" else p_Buf._Initial-SA)
      	    @ p_Buf._Initial-SA
      	(if p_Buf._Help-SA = ? then "" else p_Buf._Help-SA)
      	    @ p_Buf._Help-SA
      	(if p_Buf._Valmsg-SA = ? then "" else p_Buf._Valmsg-SA)
      	    @ p_Buf._Valmsg-SA
      	with frame fld_string_attrs.

do ON ERROR UNDO,LEAVE  ON ENDKEY UNDO,LEAVE:
   /* Do the actual field assignment in GO trigger instead of using 
      update so that if an error occurs, the dialog won't flash.
   */
   enable p_Buf._Label-SA   	 when NOT p_ReadOnly
	  p_Buf._Col-label-SA  	 when NOT p_ReadOnly
	  p_Buf._Format-SA	 when NOT p_ReadOnly
	  p_Buf._Initial-SA	 when NOT p_ReadOnly
	  p_Buf._Help-SA	 when NOT p_ReadOnly
	  p_Buf._Valmsg-SA	 when NOT p_ReadOnly
      	  btn_OK  	      	 when NOT p_ReadOnly
      	  btn_Cancel
      	  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
      	  btn_Help
      	  &ENDIF
      	  with frame fld_string_attrs.

   wait-for choose of btn_OK in frame fld_string_attrs OR 
      	    GO of frame fld_string_attrs
      	    focus p_Buf._Label-SA.

   p_Modified = yes.
end.

hide frame fld_string_attrs.
hide message no-pause.
