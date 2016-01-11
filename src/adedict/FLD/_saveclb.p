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

File: _saveclb.p

Description:
   Save any changes the user made in the clob field property window.

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Donna McMann

Date Created: 07/15/03

History:
     McMann 10/14/03 Added assignment of user_env[35] to know that a "lob" is
                    being saved.

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/capab.i}
{ adedict/FLD/clobvar.i SHARED }

Define var oldname  as char CASE-SENSITIVE NO-UNDO.
Define var newname  as char CASE-SENSITIVE NO-UNDO.
Define var oldorder as integer	       	   NO-UNDO.
Define var neworder as integer	       	   NO-UNDO.
Define var junk     as logical       	   NO-UNDO.
Define var no_name  as logical 	       	   NO-UNDO.
Define var remove   as logical 	       	   NO-UNDO.
Define var stat     as logical 	       	   NO-UNDO.
Define var num      as integer	       	   NO-UNDO.

assign
   oldname  = b_Field._Field-Name
   newname  = input frame cfldprop b_Field._Field-Name
   oldorder = b_Field._Order
   neworder = input frame cfldprop b_Field._Order.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   run adecomm/_setcurs.p ("WAIT").
   
   ASSIGN b_Field._Field-name = newname
          input frame cfldprop b_Field._Order
          b_Field._Fld-Misc2[1] = CAPS(INPUT FRAME cfldprop clob-size:SCREEN-VALUE)
          b_Field._Width = wdth.

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
      ASSIGN user_env[35] = "lob".
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
   run adecomm/_setcurs.p ("").
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".



