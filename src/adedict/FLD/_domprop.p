/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _domprop.p

Description:
   Set up the domain properties window so the user can view or modify the 
   information on a domain.  Since this window is non-modal, we just do the
   set up here.  All triggers must be global.

   All of this code is in an include file so that we can use it for fields
   and domains.

Author: Laura Stern

Date Created: 02/05/92 

----------------------------------------------------------------------------*/

/*------------------------------------------------------------------
   Comment out the whole thing until (if ever) we support domains)

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}



find _File "_Field".  /* FIX? or do we look for _Domain table? */
if NOT can-do(_File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see domain definitions."
      view-as ALERT-BOX ERROR buttons Ok in window s_win_Browse.
   return.
end.

/* Don't want Cancel if moving to next domain - only when window opens */
if s_win_Dom = ? then
   s_btn_Close:label in frame domprops = "Cancel".

/* Open the window if necessary */
run adedict/_openwin.p
   (INPUT   	  "Domain Properties",
    INPUT   	  frame domprops:HANDLE,
    INPUT         {&OBJ_DOM},
    INPUT-OUTPUT  s_win_Dom).

display "" @ s_Status with frame domprops. /* clears from last time */

s_Dom_ReadOnly = (s_ReadOnly OR s_DB_ReadOnly).
if NOT s_Dom_ReadOnly then
   if NOT can-do(_File._Can-write, USERID("DICTDB")) then
   do:
      display s_NoPrivMsg +" modify domain definitions." @ s_Status
      	 with frame domprops.
      s_Dom_ReadOnly = true.
   end.

{adedict/FLD/fdprop.i &Frame 	 = "frame domprops"
      	       	       &ReadOnly = "s_Dom_ReadOnly"}


------------------------------------------------------------------*/
