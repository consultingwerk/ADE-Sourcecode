/*********************************************************************
* Copyright (C) 2010 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _okmttbl.p

Description:   
   Display and handle the multi-tenant change confirmation dialog box.

 
Author: hdaniels (copied from other dialog)
                      
Date Created: 06/24/10 

Modified:

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES


{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{prodict/pro/confirmmt.i}

DEFINE NEW GLOBAL SHARED VARIABLE gl_prompt_mt_tbl AS LOGICAL NO-UNDO INIT NO
                                             VIEW-AS TOGGLE-BOX.

DEFINE INPUT  PARAMETER pKeepdefault AS LOGICAL NO-UNDO.
DEFINE OUTPUT PARAMETER pIsbad AS LOGICAL INITIAL FALSE NO-UNDO.

DEFINE BUTTON b_yes LABEL "Yes" {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON b_no LABEL "No"   {&STDPH_OKBTN} AUTO-ENDKEY.

 
define variable cText as character no-undo. 
 

FORM
   SKIP({&TFM_WID})
   ctext 
   view-as editor size 75 by 7 no-box 
   at  3
   
   SKIP(.5)
   gl_prompt_mt_tbl   AT 3
 
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = b_yes
      &CANCEL = b_no
      &HELP   = s_btn_Help
      }
   with frame confirmation width 80
        DEFAULT-BUTTON b_yes CANCEL-BUTTON b_no
        NO-LABELS  CENTERED
        view-as DIALOG-BOX TITLE "Confirmation of multi-tenancy".

/*------------------------------Functions---------------------------------*/
  


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
   RUN "adecomm/_adehelp.p" ("dict", "CONTEXT", {&Confirm_Multi_tenancy}, ?).

/*------------------------------Mainline Code--------------------------------*/

/* assume that the user is ok with the change if they chose not to see this message */
IF gl_prompt_mt_tbl THEN
   RETURN.

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame confirmation" 
   &BOX   = "s_rect_Btns"
   &OK    = "b_yes" 
   &HELP  = "s_btn_Help" 
}


pisBad = true.
do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE
with frame confirmation:    
      cText = confirmTable(pKeepDefault).  
      cText:sensitive = true.
      cText:read-only = true.
      gl_prompt_mt_tbl:label = showAgain().
     
      display cText.  
      layout(ctext:handle). 
      update b_yes  	      
      	     b_no
      	     s_btn_Help
             gl_prompt_mt_tbl.
      	 

      ASSIGN gl_prompt_mt_tbl = INPUT gl_prompt_mt_tbl
             pisBad = false.

end.

hide frame confirmation.
 



