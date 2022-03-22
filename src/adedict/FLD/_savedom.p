/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _savedom.p

Description:
   Save any changes the user made in the domain property window. 

Returns: "error" if the save is not complete for any reason, otherwise "".

Author: Laura Stern

Date Created: 07/15/92

----------------------------------------------------------------------------*/

/*------------------------------------------------------------------
   Comment out the whole thing until (if ever) we support domains)

&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/menu.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}
{adedict/FLD/fldvar.i shared}


Define var oldname as char CASE-SENSITIVE NO-UNDO.
Define var newname as char CASE-SENSITIVE NO-UNDO.
Define var no_name as logical 	       	  NO-UNDO.

current-window = s_win_Dom.

run adedict/_blnknam.p
   (INPUT b_Field._Field-name:HANDLE in frame domprops,
    INPUT "domain", OUTPUT no_name).
if no_name then return "error".

oldname = b_Field._Field-Name.
newname = input frame domprops b_Field._Field-Name.

do ON ERROR UNDO, LEAVE  ON STOP UNDO, LEAVE:
   run adecomm/_setcurs.p ("WAIT").

   /* Triggers, validation and gateway have already been saved.  We
   	 just need to move main property values into buffer. */
   assign
      b_Field._Field-name = newname
      input frame domprops b_Field._Format
      input frame domprops b_Field._Initial
      input frame domprops b_Field._Label
      input frame domprops b_Field._Col-label
      input frame domprops b_Field._Mandatory
      input frame domprops b_Field._Decimals
      input frame domprops b_Field._Fld-case
      input frame domprops b_Field._Help
      input frame domprops b_Field._Desc.
   
   if oldname <> newname then
   do:
      /* Change name in list in browse window */
      {adedict/repname.i
         &OldName = oldname
         &NewName = newname
         &Curr    = s_CurrDom
      	 &Fill    = s_DomFill
         &List    = s_lst_Doms}
   end.

   {adedict/setdirty.i &Dirty = "true"}.
   display "Domain Modified" @ s_Status with frame domprops.
   run adecomm/_setcurs.p ("").
   return "".
end.

run adecomm/_setcurs.p ("").
return "error".
------------------------------------------------------------------*/
