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

File: _seqprop.p

Description:
   Display the sequence properties for editing.

Author: Laura Stern

Date Created: 02/21/92 
     History:  DLM Added trigger for Limit and removed enable of initial 10/19/99

----------------------------------------------------------------------------*/


{as4dict/dictvar.i shared}
{as4dict/uivar.i shared}
{as4dict/SEQ/seqvar.i shared}
{as4dict/capab.i}

Define var capab  AS CHAR NO-UNDO.


/*----------------------------Mainline code----------------------------------*/

/* Don't want Cancel if moving to next seq - only when window opens */
if s_win_Seq = ? then
   s_btn_Close:label in frame seqprops = "Cancel".

/* Open the window if necessary */
run as4dict/_openwin.p
   (INPUT   	  "AS/400 Sequence Properties",
    INPUT   	  frame seqprops:HANDLE,
    INPUT         {&OBJ_SEQ},
    INPUT-OUTPUT  s_win_Seq).

/* Run time layout for button area. Since this is a shared frame we 
   have to avoid doing this code more than once.
*/
if frame seqprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      s_win_Seq:width = s_win_Seq:width + 1
      frame seqprops:private-data = "alive".

   {adecomm/okrun.i  
      &FRAME = "frame seqprops" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }
end.

/* Find the _Sequence record to edit. */
find b_Sequence where b_Sequence._Seq-Name = s_CurrSeq.

/* Set the limit value to the upper or lower limit depending on if increment
   is positive or negative. */
if b_Sequence._Seq-Incr > 0 then
   assign
      s_Seq_Limit = b_Sequence._Seq-Max
      s_Seq_Limit:label in frame seqprops = "&Upper Limit".
else
   assign
      s_Seq_Limit = b_Sequence._Seq-Min
      s_Seq_Limit:label in frame seqprops = "&Lower Limit".

/* Assign logical fields for form */
assign 
      s_Seq_Cycle_OK = (if b_Sequence._Cycle-OK = "Y" then yes else no).

/* Set status line */
display "" @ s_Status with frame seqprops. /* clears from last time */

display b_Sequence._Seq-Name  b_Sequence._Seq-Init    b_Sequence._Seq-Incr
        s_Seq_Limit  s_Seq_Cycle_Ok
        with frame seqprops.

/* Note: the order of enables will govern the TAB order. */
if s_ReadOnly then
do:
   disable all except
	  s_btn_Close
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame seqprops.
   enable s_btn_Close
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame seqprops.
   apply "entry" to s_btn_Close in frame seqprops.
end.
else do:
   enable b_Sequence._Seq-Name  
          b_Sequence._Seq-Incr 
	      s_Seq_Limit        
	      s_Seq_Cycle_Ok      
 	      s_btn_OK             
	      s_btn_Save         
          s_btn_Close
      	  s_btn_Prev 	      
      	  s_btn_Next
      	  s_btn_Help
	  with frame seqprops.

   apply "entry" to b_Sequence._Seq-Name in frame seqprops.
end.








