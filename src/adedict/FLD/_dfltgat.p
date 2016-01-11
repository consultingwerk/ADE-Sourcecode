/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _dfltgat.p

Description:
   Default some unknown values to a reasonable default.  If the user
   never brings up the gateway dialog, this will be called to set defaults
   so the user won't get errors on adding new fields.  If the user does
   come into the gateway dialog, this will be called to set the defaults
   at that time.

Input Parameter:
   p_copy - this is being called for a copied field.  Don't do spacing
      	    processing.

Author: Laura Stern

Date Created: 08/16/93

----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adedict/FLD/fldvar.i shared}

DEFINE INPUT PARAMETER p_copy AS LOGICAL NO-UNDO.

Define var db_type as char NO-UNDO.
Define var odbtyp  as char NO-UNDO.

/*==========================Internal Procedures==============================*/

/*-----------------------------------------------------------------------
   The field offset for a new field is based on the offset and length
   of the last field.  Otherwise, it is the stored offset value.

   Spacing is used when elements in array are not contiguous. It tells 
   how far away the next array element is.  Clearly it must not be less
   than the field length so default it wisely.

-----------------------------------------------------------------------*/
Procedure Set_FlatFile_Defaults:

   Define var ext as integer NO-UNDO.

   if b_Field._Fld-stoff = ? then
   do:
      find LAST _Field USE-INDEX _Field-Position 
      	 where _Field._File-recid = s_TblRecId AND
      	       _Field._Field-name <> b_Field._Field-name.

      b_Field._Fld-stoff = 
      	 (if AVAILABLE _Field 
      	     then _Field._Fld-stoff 
                  + (if _Field._Fld-stlen < _Field._For-spacing
                     then _Field._For-spacing else _Field._Fld-stlen)
                  * (if _Field._Extent > 1 then _Field._Extent else 1)
             else ?).
   end.
   
   if NOT p_copy then 
   do:
      ext = (if s_Adding then input frame newfld b_Field._Extent
			 else input frame fldprops b_Field._Extent).
      if ext > 0 AND b_Field._For-spacing = ? AND b_Field._Fld-stlen > 0 then
	 b_Field._For-spacing = b_Field._Fld-stlen.
   end.
end.


/*-----------------------------------------------------------------------
   The field offset for a new field is a sequential column #.  This
   must be set for the field to be added properly.

-----------------------------------------------------------------------*/
Procedure Set_ODBC_Defaults:
   if b_Field._Fld-stoff = ? then
   do:
      define query qry for _Field.
      open query qry 
        for each _Field 
      	  where _Field._File-recid = s_TblRecId AND
      	        _Field._Field-name <> b_Field._Field-name
          by _Field._Fld-stoff.
      get last qry.

      b_Field._Fld-stoff = 
      	 (if AVAILABLE _Field 
      	     then _Field._Fld-stoff + 1
             else 1
         ).
      close query qry.
   end.
   if b_Field._For-Name = ? then
      b_Field._For-Name = "NONAME".
end.


/*==============================Mainline Code================================*/

assign
  db_type = s_DbCache_Type[s_DbCache_ix]
  odbtyp  = {adecomm/ds_type.i
               &direction = "ODBC"
               &from-type = "db_type"
            }.

/* Run the appropriate routine, based on the gateway. */
case (db_type):
   when "CISAM" OR
   when "NETISAM" OR
   when "CTOSISAM" OR
   when "RMS" then
      run Set_FlatFile_Defaults.

   otherwise if can-do(odbtyp,db_type) then
      run Set_ODBC_Defaults.
end.




