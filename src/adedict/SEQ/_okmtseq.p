/*********************************************************************
* Copyright (C) 2010 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _okmtseq.p

Description:   
   Display and handle the multi-tenant change confirmation dialog box.

Returns:  
    
Author: hdaniels
                      
Date Created: 06/26/10

Modified:

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES


{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{prodict/pro/confirmmt.i}
DEFINE NEW GLOBAL SHARED VARIABLE gl_prompt_mt_seq AS LOGICAL NO-UNDO INIT NO
                                             VIEW-AS TOGGLE-BOX.

DEFINE BUTTON b_yes LABEL "Yes" {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON b_no LABEL "No"   {&STDPH_OKBTN} AUTO-ENDKEY.

define var retval           as char NO-UNDO init "". /* return value */
define variable cText as character no-undo. 
define variable cConfirm as character no-undo. 



FORM
   SKIP({&TFM_WID})
   cText   at  3
   view-as editor size 70 by 2 no-box     	       	        
   SKIP(.3)
   cConfirm at  3 
   view-as TEXT 
   SKIP(.5)
   gl_prompt_mt_seq  AT 3
 
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = b_yes
      &CANCEL = b_no
      &HELP   = s_btn_Help
      }
   with frame confirmation
        DEFAULT-BUTTON b_yes CANCEL-BUTTON b_no
        NO-LABELS  CENTERED
        view-as DIALOG-BOX TITLE "Confirmation of multi-tenancy".



/*------------------------------Trigger Code---------------------------------*/

/*-----WINDOW-CLOSE-----*/
on window-close of frame confirmation
   apply "END-ERROR" to frame confirmation.

/*----- SELECTION of OK BUTTON or GO -----*/
/*
on GO of frame confirmation	   /* or OK due to AUTO-GO */
do:
   retval = "mod".
end.
*/

/*----- HELP -----*/

on HELP of frame confirmation OR choose of s_btn_Help in frame confirmation
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Field_Properties_Window}, ?).

/*------------------------------Mainline Code--------------------------------*/

/* assume that the user is ok with the change if they chose not to see this message */
IF gl_prompt_mt_seq THEN
   RETURN.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame confirmation" 
   &BOX   = "s_rect_Btns"
   &OK    = "b_yes" 
   &HELP  = "s_btn_Help" 
}
retval = "error".
do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE
with frame confirmation:
      cText = confirmSequence().   
      cConfirm = confirmYes("s":U,yes).   
      cConfirm:format = "x(" + string(length(cconfirm)) + ")".
      cText:sensitive = true.
      cText:read-only = true.
      gl_prompt_mt_seq:label = showAgain().
      display cText cConfirm.
      update b_yes  	      
      	     b_no
      	     s_btn_Help
             gl_prompt_mt_seq.
      	 

      ASSIGN retval = "".
             gl_prompt_mt_seq = INPUT gl_prompt_mt_seq.
end.

hide frame confirmation.
return retval.



