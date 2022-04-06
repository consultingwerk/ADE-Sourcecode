/***********************************************************************
* Copyright (C) 2000-2010 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

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
              09/26/02 D. McMann Added check for SQL table
----------------------------------------------------------------------------*/

/*---------------------------- Declarations --------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}
{prodict/pro/arealabel.i}
/*----------------------------Mainline code----------------------------------*/

find dictdb._File where dictdb._File._File-name = "_Field"
             and dictdb._File._Owner = "PUB" NO-LOCK.
if NOT can-do(dictdb._File._Can-read, USERID("DICTDB")) then
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
   if NOT can-do(dictdb._File._Can-write, USERID("DICTDB")) then
   do:
      s_Status:screen-value in frame fldprops = 
      	 s_NoPrivMsg + " modify field definitions.".
      s_Fld_ReadOnly = true.
   end.
   else do:
      find dictdb._File where RECID(dictdb._File) = s_TblRecId.
       
      if dictdb._File._Frozen then
      do:
      	 s_Status:screen-value in frame fldprops =
      	    "Note: This table is frozen and cannot be modified.".
      	 s_Fld_ReadOnly = true.
      end.
      ELSE IF dictdb._File._Db-lang > {&TBLTYP_SQL} THEN DO:
        s_Status:screen-value in frame fldprops =
      	    "Note: {&PRO_DISPLAY_NAME}/SQL92 table cannot be modified.".
      	 s_Fld_ReadOnly = true.
      END.
   end.
end.
else do:
    find dictdb._File where RECID(dictdb._File) = s_TblRecId.
end.    

{adedict/FLD/fdprop.i &Frame    = "frame fldprops"
      	       	       &ReadOnly = "s_Fld_ReadOnly"}









