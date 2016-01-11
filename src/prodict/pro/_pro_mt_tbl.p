/*********************************************************************
* Copyright (C) 2010 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _pro_mt_table.p

Description:   
   Display and handle the multi-tenant change confirmation dialog box.

Returns: "" if user OK'ed change
      	 "error" if user Cancels.

Modified:

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{adecomm/adestds.i}
{ prodict/pro/confirmmt.i }

DEFINE NEW GLOBAL SHARED VARIABLE gl_prompt_mt_tbl AS LOGICAL NO-UNDO INIT NO
                                             VIEW-AS TOGGLE-BOX.


DEFINE INPUT  PARAMETER pKeepdefault AS LOGICAL NO-UNDO.
DEFINE OUTPUT PARAMETER pIsbad AS LOGICAL INITIAL FALSE NO-UNDO.

DEFINE BUTTON b_yes LABEL "Yes" {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON b_no LABEL "No"   {&STDPH_OKBTN} AUTO-ENDKEY.

define variable cText as character no-undo. 
 
form
/*   SKIP({&TFM_WID})*/
   ctext 
   view-as editor size 76 by 14 no-box  
   at  2
/*   SKIP          */
/*   cconfirm at  2*/
/*   view-as TEXT*/
   SKIP(1)
   gl_prompt_mt_tbl   AT 2

   {adecomm/okform.i
      &STATUS = no
      &OK     = b_yes
      &CANCEL = b_no
      }
   
   with frame confirmation
        DEFAULT-BUTTON b_yes CANCEL-BUTTON b_no
        NO-LABELS  CENTERED
        view-as DIALOG-BOX TITLE "Confirmation of multi-tenancy".

/*------------------------------Trigger Code---------------------------------*/

/*----- SELECTION of OK BUTTON or GO -----*/
/*
on GO of frame confirmation	   /* or OK due to AUTO-GO */
do:

end.
*/

/*------------------------------Mainline Code--------------------------------*/

/* assume that the user is ok with the change if they chose not to see this message */
IF gl_prompt_mt_tbl THEN
   RETURN "".

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame confirmation" 
   &BOX   = "s_rect_Btns"
   &OK    = "b_yes" 
   &CANCEL = "b_no"
}
pIsBad = true.
do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE
with frame confirmation:
      cText = confirmTable(pKeepDefault)  .
      gl_prompt_mt_tbl:label = showAgain().
      display cText.
      layout(ctext:handle). 
      update b_yes  	      
      	     b_no
             gl_prompt_mt_tbl
      	     with frame confirmation.

      ASSIGN pIsBad = false.
             gl_prompt_mt_tbl.
end.

hide frame confirmation.




