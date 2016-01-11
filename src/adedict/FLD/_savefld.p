/*********************************************************************
* Copyright (C) 2006,2010 by Progress Software Corporation. All rights    *
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
    fernando 06/08/06 Added support for int64
    fernando 04/08/08 Remove time field for ORACLE if changing to datetime
    sgarg    06/24/10 Reset _Fld-Misc1[7] to ? for MSS if changing from LOB to CHAR.

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

DEFINE BUFFER tmpField FOR DICTDB._Field.
DEFINE BUFFER tmpFile  FOR DICTDB._File.

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
   if b_Field._Data-type <> s_Fld_Protype THEN DO:
      /* if moving from date to datetime for an ORACLE schema, check if
         schema contains the time portion for the date field, and remove it.
      */
      IF s_DbCache_Type[s_DbCache_ix] = "ORACLE" AND
         (b_field._dtype = {&DTYPE_DATE} OR b_field._dtype = {&DTYPE_CHARACTER})
         AND s_Fld_Protype BEGINS "datetime" THEN DO:

         FIND FIRST tmpField WHERE tmpField._File-recid = 
             b_field._File-recid AND tmpField._For-name = b_field._For-name AND
             tmpField._For-type = "TIME" NO-ERROR.

         IF AVAILABLE tmpField THEN DO:
             /* remove it from the browse view */
            stat = s_lst_Flds:delete(tmpField._field-name) in frame browse.
            DELETE tmpField. /* delete it */
         END.
      END.

      /* if changing mapping for a field from LOB to CHAR in an MSS stored procedure,
         reset _fld-misc1[7] from 1 to ?.
      */
      IF s_DbCache_Type[s_DbCache_ix] = "MSS" AND
         (b_field._dtype = {&DTYPE_CLOB} OR b_field._dtype = {&DTYPE_BLOB})
         AND s_Fld_Protype BEGINS "character" THEN DO:

         FIND tmpFile of b_field WHERE tmpFile._For-type = "PROCEDURE" NO-LOCK NO-ERROR.
         IF AVAILABLE tmpFile THEN DO:
             if b_field._fld-misc1[7] = 1 then 
                b_field._fld-misc1[7] = ?.
         END.
      END.

      b_Field._Data-type = s_Fld_Protype.
   END.
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
       IF b_field._dtype = {&DTYPE_INT64} OR b_Field._Data-type = "int64" THEN DO:
          IF DECIMAL(B_Field._Initial:SCREEN-VALUE) > 9223372036854775807 OR 
             DECIMAL(B_Field._Initial:SCREEN-VALUE) < -9223372036854775808 THEN DO:
              MESSAGE "Initial Value has value too large for int64"
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
              RUN adecomm/_setcurs.p ("").
              RETURN "error".
          END.
       END.

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



