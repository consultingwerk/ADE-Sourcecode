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

File: _prcprop.p

Description:
   Display procedure properties for the current procedure in the edit window.

Author: Donna McMann

Date Created: 04/27/99          

----------------------------------------------------------------------------*/

{as4dict/menu.i shared}
{as4dict/dictvar.i shared}
{as4dict/uivar.i shared}
{as4dict/prc/procvar.i shared}
{as4dict/capab.i}
/*======================Triggers for Procedure Properties=======================*/
  
/*----------------------------Mainline code----------------------------------*/

Define var name_editable as logical NO-UNDO.
Define var capab     	 as char    NO-UNDO.
Define var junk	     	 as logical NO-UNDO.
Define var ronote                  as character NO-UNDO.

/* Don't want Cancel if moving to next table - only when window opens */
if s_win_Proc = ? then
   s_btn_Close:label in frame prcprops = "Cancel".

/* Open the window if necessary */
run as4dict/_openwin.p
   (INPUT   	  "AS/400 Procedure Properties",
    INPUT   	  frame prcprops:HANDLE,
    INPUT         {&OBJ_PROC},
    INPUT-OUTPUT  s_win_Proc).
 
/* Run time layout for button area.  This defines eff_frame_width.
   Since this is a shared frame we have to avoid doing this code more
   than once.
*/
if frame prcprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      frame prcprops:private-data = "alive"
      s_win_Proc:width = s_win_Proc:width + 1.  

   {adecomm/okrun.i  
      &FRAME = "frame prcprops" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }

   /* So Return doesn't hit default button in editor widget */
   b_Proc._Desc:RETURN-INSERT in frame prcprops = yes.

   /* runtime adjustment of "Optional" title band to the width of the frame */
   s_Optional:width-chars in frame prcprops = eff_frame_width - 
      	       	     	      	       	      ({&HFM_WID} * 2).
end.

/* Get the record for the selected procedure */
find b_Proc where b_Proc._File-number = s_ProcForNo.

ASSIGN s_AS400_Proc_name = b_Proc._AS4-File
       s_AS400_libr_name = b_Proc._as4-library.

/* Set the status line */
display "" @ s_Status with frame prcprops. /* clears from last time */

ASSIGN s_Proc_ReadOnly =  s_ReadOnly.   

display  b_Proc._File-Name
         s_AS400_Proc_Name
         s_AS400_Libr_Name
      	 s_optional   	 
         b_Proc._Desc
      	         
   with frame prcprops.
      	 
if s_Proc_ReadOnly then
do:  
   
   disable all except               	  
	  s_btn_Close 
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help
	  with frame prcprops.   
	  
   enable s_btn_Close 
	  s_btn_Prev
	  s_btn_Next
	  s_btn_Help      
	  with frame prcprops.                                         
 
   apply "entry" to s_btn_Close in frame prcprops.
end.
else do: 
   /* Note: the order of enables will govern the TAB order. */
   enable b_Proc._File-Name   
          s_AS400_Proc_Name
          s_AS400_Libr_Name	  
	  b_Proc._Desc	  
      	  s_btn_OK
	  s_btn_Save
	  s_btn_Close
      	  s_btn_Prev
      	  s_btn_Next
      	  s_btn_Help
	  with frame prcprops.

 
      apply "entry" to b_Proc._File-Name in frame prcprops.
 
end.




