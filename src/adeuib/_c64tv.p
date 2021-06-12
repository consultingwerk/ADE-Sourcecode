/***********************************************************************
* Copyright (C) 2014-2021 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
************************************************************************/

/*----------------------------------------------------------------------------

File: c64tv.p
Description:   
   Display and handle the confirmation dialog box when opening a file in 
   64-bit Windows using 64-bit OE install


Author: Rohit Kumar
                    
Date Created: 11/12/2014

Modified: tmasood 03/02/2021 Stop the message to display again

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{adedict/dictvar.i shared}
{adedict/uivar.i shared}
DEFINE NEW GLOBAL SHARED VARIABLE l_show AS LOGICAL NO-UNDO INIT NO
                                             VIEW-AS TOGGLE-BOX.

DEFINE BUTTON b_yes LABEL "OK" {&STDPH_OKBTN} AUTO-GO.

DEFINE VARIABLE cChoice AS CHARACTER NO-UNDO INITIAL "Show". /* User's selection */
Define var retval as char NO-UNDO init "". /* return value */

FORM
   SKIP({&TFM_WID})
   "Viewing internal procedures and functions in the AppBuilder tree-view":t71  at  3 
      	       	    view-as TEXT 
   SKIP
   "is not supported on the 64-bit Windows platform. You can still use the":t71  at  3 
      	       	    view-as TEXT 
   SKIP
   "Section Editor to view the contents of these procedures and functions.":t71  at  3 
                      view-as TEXT 
   SKIP
   "Note that the Outline View feature in Progress Developer Studio for":t70  at  3 
                      view-as TEXT 
   SKIP
   "OpenEdge supports the viewing of internal procedures and functions in":t70  at  3 
                      view-as TEXT 
   SKIP 
   "a tree-view on the 64-bit Windows platform. ":t70 at 3                   
   SKIP(.5)
   l_show LABEL "&Don't show me this again (for this session)" AT 3
 
   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = no
      &OK     = b_yes
      }
   with frame confirmation
        DEFAULT-BUTTON b_yes 
        NO-LABELS  CENTERED
        view-as DIALOG-BOX TITLE " Unable to display Treeview ".

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


/*------------------------------Mainline Code--------------------------------*/

/* assume that the user is ok with the change if they chose not to see this message */
IF l_show THEN
   RETURN "mod".

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "frame confirmation" 
   &BOX   = "s_rect_Btns"
   &OK    = "b_yes" 

}

do ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE  ON STOP UNDO, LEAVE:
      update b_yes  	      
      	     l_show
      	     with frame confirmation.

      ASSIGN retval = "mod".
             l_show = INPUT FRAME confirmation l_show.
end.
/* Don't show the message again */
IF l_show:SCREEN-VALUE = "YES" THEN cChoice = "Hide".
PUT-KEY-VALUE SECTION "ProAB" KEY "Disabled_TreeView_Message" VALUE cChoice NO-ERROR.

hide frame confirmation.
return retval.



