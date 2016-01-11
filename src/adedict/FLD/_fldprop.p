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

File: _fldprop.p

Description:
   Set up the field properties window so the user can view or modify the 
   information on a field.  Since this window is non-modal, we just do the
   set up here.  All triggers must be global.

   All of this code is in an include file so that we can use it for fields
   and domains.

Author: Laura Stern

Date Created: 02/05/92 
    Modified: 07/14/98 D. McMann Added _Owner to _File find
              05/19/99 Mario B.  Adjust Width Field browser integration.
----------------------------------------------------------------------------*/

/*---------------------------- Declarations --------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}

/*----------------------------Mainline code----------------------------------*/

find _File where _File._File-name = "_Field"
             and _File._Owner = "PUB" NO-LOCK.
if NOT can-do(_File._Can-read, USERID("DICTDB")) then
do:
   message s_NoPrivMsg "see field definitions."
      view-as ALERT-BOX ERROR buttons Ok in window s_win_Browse.
   return.
end.

/* Don't want Cancel if moving to next field - only when window opens */
if s_win_Fld = ? then
   s_btn_Close:label in frame fldprops = "Cancel".

/* Open the window if necessary */
run adedict/_openwin.p
   (INPUT   	  "Field Properties",
    INPUT   	  frame fldprops:HANDLE,
    INPUT         {&OBJ_FLD},
    INPUT-OUTPUT  s_win_Fld).

/* Have to run graying so that Adjust Width Browser can't be opened when *
 * when this window is open                                              */
RUN adedict/_brwgray.p (INPUT NO).

/* We haven't finished fiddling with frame yet so to set status line
   don't use display statement.
*/
s_Status:screen-value in frame fldprops = "". /* clears from last time */

s_Fld_ReadOnly = (s_ReadOnly OR s_DB_ReadOnly).
if NOT s_Fld_ReadOnly then
do:
   if NOT can-do(_File._Can-write, USERID("DICTDB")) then
   do:
      s_Status:screen-value in frame fldprops = 
      	 s_NoPrivMsg + " modify field definitions.".
      s_Fld_ReadOnly = true.
   end.
   else do:
      find _File where RECID(_File) = s_TblRecId.
      if _File._Frozen then
      do:
      	 s_Status:screen-value in frame fldprops =
      	    "Note: This table is frozen and cannot be modified.".
      	 s_Fld_ReadOnly = true.
      end.
   end.
end.

{adedict/FLD/fdprop.i &Frame    = "frame fldprops"
      	       	       &ReadOnly = "s_Fld_ReadOnly"}









