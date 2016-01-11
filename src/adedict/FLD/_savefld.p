/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _savefld.p

Description:
   Save any changes the user made in the field property window.

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Laura Stern

Date Created: 07/15/92

History:
    tomn    7/96    Added condition on assigment for _decmimals field to not
                    write the unknown value (?) to the database.  The idea 
                    being that this is the default value for this field, so it
                    should not change if it is never enabled (i.e., _decimals
                    is not appropriate for that data type), but in the case of
                    some foreign char fields where we store size information in
                    this field, we display a "?" on the screen instead, and we
                    will not be overwriting the size info with "?". 

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/capab.i}


Define var oldname  as char CASE-SENSITIVE NO-UNDO.
Define var newname  as char CASE-SENSITIVE NO-UNDO.
Define var oldorder as integer	       	   NO-UNDO.
Define var neworder as integer	       	   NO-UNDO.
Define var junk     as logical       	   NO-UNDO.
Define var no_name  as logical 	       	   NO-UNDO.
Define var remove   as logical 	       	   NO-UNDO.
Define var stat     as logical 	       	   NO-UNDO.
Define var num      as integer	       	   NO-UNDO.

current-window = s_win_Fld.

run adedict/_blnknam.p
   (INPUT b_Field._Field-name:HANDLE in frame fldprops,
    INPUT "field", OUTPUT no_name).
if no_name then return "error".

run adedict/FLD/_valgate.p.
if RETURN-VALUE = "error" then return "error".

assign
   oldname  = b_Field._Field-Name
   newname  = input frame fldprops b_Field._Field-Name
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

   assign
      b_Field._Field-name = newname
      input frame fldprops b_Field._Format
      input frame fldprops b_Field._Order
      input frame fldprops b_Field._Desc.

   /* For a Progress db, most fields are not valid for CLOB/BLOB fields */
   IF {adedict/ispro.i} AND (b_field._dtype = {&DTYPE_BLOB} OR  b_field._dtype = {&DTYPE_CLOB}) THEN DO:
      ASSIGN b_Field._Fld-Misc2[1] = input frame fldprops s_lob_size.
             b_Field._Width = s_lob_wdth.
   END.
   ELSE DO:
       ASSIGN
           input frame fldprops b_Field._Help
           input frame fldprops b_Field._Initial
           input frame fldprops b_Field._Label
           input frame fldprops b_Field._Col-label
           input frame fldprops b_Field._Mandatory
           input frame fldprops b_Field._Decimals
             when b_field._decimals:screen-value ne "?":u.
   END.

   if b_Field._Extent:visible in frame fldprops AND
      b_Field._Extent:sensitive in frame fldprops then
      assign input frame fldprops b_Field._Extent.

   if b_Field._Fld-case:visible in frame fldprops AND
      b_Field._Fld-case:sensitive in frame fldprops then
      assign input frame fldprops b_Field._Fld-case.

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
      run adedict/FLD/_ptinlst.p (INPUT newname, INPUT neworder).
   end.
   else if oldname <> newname then
   do:
      /* Just change the name in place */
      {adedict/repname.i
	 &OldName = oldname
	 &NewName = newname
	 &Curr    = s_CurrFld
	 &Fill    = s_FldFill
	 &List    = s_lst_Flds}
   end.

   {adedict/setdirty.i &Dirty = "true"}.
   display "Field Modified" @ s_Status with frame fldprops.
   run adecomm/_setcurs.p ("").
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".



