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

File: _valgate.p

Description:
   Do some gateway related validation when the user tries to add or modify
   a field.

Returns: "error" if an error was detected or "ok" otherwise.

Author: Laura Stern

Date Created: 09/30/92 

----------------------------------------------------------------------------*/


&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adecomm/cbvar.i shared}
{adedict/uivar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/capab.i}

Define var decim as integer NO-UNDO.

if INDEX(s_Fld_Capab, {&CAPAB_OFFLEN_REQ}) <> 0 then
do:
   if b_Field._Fld-stoff = ? then
   do:
      message "You must enter a position (record offset) for this field." SKIP
      	      "Select the ""Data Server..."" button to enter a value."
      	      view-as ALERT-BOX ERROR buttons OK.
      return "error".
   end.

   if b_Field._Fld-stlen = 0 then
   do:
      message "Field length must be greater than 0." SKIP
      	      "Select the ""Data Server..."" button to enter a value."
      	      view-as ALERT-BOX ERROR buttons OK.
      return "error".
   end.
end.

if INDEX(s_Fld_Capab, {&CAPAB_DECIMALS_REQ}) <> 0 then
   decim = (if s_Adding then input frame newfld b_Field._Decimals
      	       	     	else input frame fldprops b_Field._Decimals).
   if decim = ? AND s_Fld_Typecode = {&DTYPE_DECIMAL} then
   do:
      message "You must enter a value for Decimals."
      	      view-as ALERT-BOX ERROR buttons OK.
      return "error".
   end.

/* in RMS the scale needs to be between -10 and 50 for Binary Types
 * and between -127 and 127 for other types.
 * We check for that in the DataServer window (adedict/FLD/_fldgate.p).
 * However, an User could have a field of an "other" type with a scale
 * outside the range for a binary-type, and try to change the type from
 * this "other" type to a binary type. We want to disallow to save this
 * field in such a case. So we check for that here
 * RDB might work the same, so we inlcude it in the if-condition
 *                                                     (hutegger 03/95)
 */
if  s_DbCache_Type[s_DbCache_ix] = "RMS"
 or s_DbCache_Type[s_DbCache_ix] = "RDB"
 then do:
  if ( b_Field._For-Scale <= -10 OR b_Field._For-Scale >= 50 )
   AND CAN-DO( "SBin1,SBin2,SBin4,SBin8"
             , b_Field._For-Type
             )
   then do:
     message
       "Scale must be between -10 and +50 for Scaled Unsigned types." skip
       "Choose the button ~"Data Server~" and adjust the scale." 
       view-as ALERT-BOX ERROR buttons OK.
     return "error".
     end.

   else if b_Field._For-Scale <= -127 OR b_Field._For-Scale >= 127
    then do:
     message
       "Scale must be between -127 and +127."                   skip
       "Choose the button ~"Data Server~" and adjust the scale."
       view-as ALERT-BOX ERROR buttons OK.
     return "error".
     end.
 
   end.
  
return "ok".



