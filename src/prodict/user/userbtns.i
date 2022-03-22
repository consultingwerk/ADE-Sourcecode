/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: userbtns.i

Description:   
   Adds an OK and Cancel button and the rectangle that underlies them,
   to a frame.  

Text-Parameters:
    &OTHER      other buttons for both TTY AND GUI frames
    &OTHERGUI   other buttons for GUI frames ONLY
    &OTHERTTY   other buttons for TTY frames ONLY
    
Author: Laura Stern

Date Created: 11/17/92 

Modified:
    hutegger    94-09-12    added text-parameters which can get omitted
    
----------------------------------------------------------------------------*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
   {adecomm/okform.i
      &BOX    = rect_btns
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      &OTHER  = " {&OTHER}{&OTHERGUI}"
      &HELP   = btn_Help}
&ELSE
   {adecomm/okform.i
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      &OTHER  = " {&OTHER}{&OTHERTTY}"}
&ENDIF

