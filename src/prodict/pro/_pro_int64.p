/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _pro_int64.p

Description:   
   Display and handle the int->int64 change confirmation dialog box.

Returns: "mod" if user OK'ed change
      	 "" if user Cancels.

Author: Fernando de Souza
                      
Date Created: 06/08/06

Modified:

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE NEW GLOBAL SHARED VARIABLE l_show AS LOGICAL NO-UNDO INIT NO
                                             VIEW-AS TOGGLE-BOX.

DEFINE BUTTON b_yes LABEL "Yes" {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON b_no LABEL "No"   {&STDPH_OKBTN} AUTO-ENDKEY.

Define var retval as char NO-UNDO init "". /* return value */

form
   SKIP({&TFM_WID})
   "If you change this field's data type to int64,  you will not be able to":t71  at  3 
      	       	    view-as TEXT 
    SKIP
   "change the data type back to integer after you commit the changes.":t70  at  3 
      	       	    view-as TEXT 
    SKIP
    "To revert this change back, you will need to dump/load this table.":t72  at  3 
                      view-as TEXT 
    SKIP
     "Do you really want to change this field's data type?"  at  3 
                      view-as TEXT 

    SKIP(1)
    l_show LABEL "&Don't show me this again (for this session)" AT 3

   {adecomm/okform.i
      &STATUS = no
      &OK     = b_yes
      &CANCEL = b_no
      }
   
   with frame confirmation
        DEFAULT-BUTTON b_yes CANCEL-BUTTON b_no
        NO-LABELS  CENTERED
        view-as DIALOG-BOX TITLE "Confirmation of data type change".

/*------------------------------Trigger Code---------------------------------*/

/*----- SELECTION of OK BUTTON or GO -----*/
/*
on GO of frame confirmation	   /* or OK due to AUTO-GO */
do:

end.
*/

/*------------------------------Mainline Code--------------------------------*/

/* assume that the user is ok with the change if they chose not to see this message */
IF l_show THEN
   RETURN "mod".

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame confirmation" 
   &BOX   = "s_rect_Btns"
   &OK    = "b_yes" 
   &CANCEL = "b_no"
}

do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
      update b_yes  	      
      	     b_no
             l_show
      	     with frame confirmation.

      ASSIGN retval = "mod".
             l_show = INPUT FRAME confirmation l_show.
end.

hide frame confirmation.
return retval.



