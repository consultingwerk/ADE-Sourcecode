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

File: _savefld.p

Description:
   Save any changes the user made in the field property window.

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Laura Stern

Date Created: 07/15/92
              01/1995    Modified to work with PROGRESS/400 Data Dictionary
              07/25/96 D. McMann added assign to _File-misc2[5][1] = Y for
                       ade maintenance flag.
----------------------------------------------------------------------------*/


{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}
{as4dict/menu.i shared}
{as4dict/uivar.i shared}
{adecomm/cbvar.i shared}
{as4dict/FLD/fldvar.i shared}
{as4dict/capab.i}


Define var oldname  as char CASE-SENSITIVE NO-UNDO.
Define var newname  as char CASE-SENSITIVE NO-UNDO.    
Define var newfname as char                                    NO-UNDO.
Define var oldorder as integer	       	   NO-UNDO.
Define var neworder as integer	       	   NO-UNDO.
Define var junk     as logical       	   NO-UNDO.
Define var no_name  as logical 	       	   NO-UNDO.
Define var remove   as logical 	       	   NO-UNDO.
Define var stat     as logical 	       	   NO-UNDO.
Define var num      as integer	       	   NO-UNDO.

current-window = s_win_Fld.

run as4dict/_blnknam.p
   (INPUT b_Field._Field-name:HANDLE in frame fldprops,
    INPUT "field", OUTPUT no_name).
if no_name then return "error".

if RETURN-VALUE = "error" then return "error".

assign
   oldname  = b_Field._Field-Name
   newname  = input frame fldprops b_Field._Field-Name      
   newfname = CAPS(INPUT FRAME fldprops b_Field._For-name)
   oldorder = b_Field._Order
   neworder = input frame fldprops b_Field._Order.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   run adecomm/_setcurs.p ("WAIT").
   
   /* Triggers, validation and gateway have already been saved.  We
      just need to move main property values into buffer.  For data types
      check if changed first. Progress, normally won't let you change
      data types.
   */
   if b_Field._Data-type <> s_Fld_Protype then
      b_Field._Data-type = s_Fld_Protype.
   if b_Field._For-type <> s_Fld_Gatetype then
      b_Field._For-type = s_Fld_Gatetype.
   
   /* If order number is changed and field is an extent field,  the others must have new
        number.  Find all AS400 extent fields and change order number */
    if b_Field._Extent > 0 and (input frame fldprops b_Field._Order <> b_Field._Order)
    then do:
        for each as4dict.p__Field where as4dict.p__Field._File-number = b_Field._File-number
                                                                and as4dict.p__Field._Fld-misc1[7] = b_Field._Order:
              assign as4dict.p__Field._Fld-misc1[7] = input frame fldprops b_Field._Order.
        end.
   end.
   IF b_Field._For-name <> newfname THEN DO:
        FOR EACH as4dict.p__Idxfd WHERE as4dict.p__Idxfd._File-number = b_Field._File-number
                                                                      AND as4dict.p__Idxfd._Fld-number = b_Field._Fld-number:
                 ASSIGN as4dict.p__Idxfd._If-Misc2[2] = newfname.
         END.
   END.
                                                                                                                                   
   assign
      b_Field._Field-name = newname     
      b_Field._For-name = newfname
      input frame fldprops b_Field._Format
      input frame fldprops b_Field._Initial
      input frame fldprops b_Field._Label
      input frame fldprops b_Field._Col-label
      input frame fldprops b_Field._Decimals
      input frame fldprops b_Field._Order
      input frame fldprops b_Field._Help
      input frame fldprops b_Field._Desc.       
      
   /*  Fill the fields which would normally be logicals in a PROGRESS
   schema, but since they AS400 fields they need to be converted from
   logical to Alpha.  These fields are displayed in the frame TBLPROPS
   as logicals (toggle box).  */

   b_Field._Mandatory = 
      (if input frame fldprops s_Fld_Mandatory then "Y" else "N").
   b_Field._Fld-Misc2[2]  = 
      (if input frame fldprops s_Fld_Null_Capable then "Y" else "N").

   if b_Field._Extent:visible in frame fldprops AND
      b_Field._Extent:sensitive in frame fldprops then
      assign input frame fldprops b_Field._Extent.

  /* Set _Fil-Misc1[1] so that sync will know that file has changed if change does
       not require a DDS change */
    find as4dict.p__File where as4dict.p__File._File-number = s_TblForNo.         
    ASSIGN  as4dict.p__File._Fil-Misc1[1] = as4dict.p__File._Fil-Misc1[1] + 1
                      as4dict.p__File._Fil-res1[8] = 1.         
    IF as4dict.p__File._Fil-res1[7] < 0 then assign as4dict.p__File._Fil-res1[7] = 0.    

    IF SUBSTRING(as4dict.p__File._Fil-misc2[5],1,1) <> "Y" THEN
       ASSIGN SUBSTRING(as4dict.p__File._fil-misc2[5],1,1) = "Y".                  

   /* For certain gateways we store the character length in the _Decimals
      field to support certain SQL operations.
   */
   if (s_Fld_TypeCode = {&DTYPE_CHARACTER} AND 
       INDEX(s_Fld_Capab, {&CAPAB_CHAR_LEN_IN_DEC}) <> 0) then
      b_Field._Decimals = b_Field._Fld-stlen.

  
   /* Determine if we have to remove the field's entry in the browse list
      to reposition it based on a new name or order#.  If there's only
      one field we don't have to bother.
   */
   remove = no.
   num = s_lst_Flds:NUM-ITEMS in frame browse.
   if oldname <> newname AND
      s_Order_By = {&ORDER_ALPHA} AND
      num > 1 then
      	 remove = yes.
   if NOT remove AND 
      oldorder <> neworder AND
      s_Order_By = {&ORDER_ORDER#} AND
      num > 1 then
      	 remove = yes.

   if remove then 
   do:
      stat = s_lst_Flds:delete(oldname) in frame browse.
      run as4dict/FLD/_ptinlst.p (INPUT newname, INPUT neworder).
   end.
   else if oldname <> newname then
   do:
      /* Just change the name in place */
      {as4dict/repname.i
	 &OldName = oldname
	 &NewName = newname
	 &Curr    = s_CurrFld
	 &Fill    = s_FldFill
	 &List    = s_lst_Flds}
   end.

   {as4dict/setdirty.i &Dirty = "true"}.          
   /* Must force release of record to DataServer but do not want to loose record so
        issue a validate with no-error.  */
   VALIDATE b_field NO-ERROR.
   display "Field Modified" @ s_Status with frame fldprops.
   run adecomm/_setcurs.p ("").
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".



