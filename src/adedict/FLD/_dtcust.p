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

File: _dtcust.p

Description:
   Do data type customization.  This means changing visibility or labels
   of fields based on their relevance to the currently selected data type.
   For the fields affected, also take gateway capabilities and other 
   factors into account.

Shared Input:
   s_Fld_Typecode - The underlying code for data type
   s_Fld_Gatetype - The gateway data type.

Input Parameters:
   p_Case - Widget handle for the case sensitive widget.
   p_Dec  - Widget handle for the decimals widget.

Author: Laura Stern

Date Created: 10/02/92

History:
    tomn    07/96   Changed code to set the screen-value of the _decimals
                    field to "?" when field was disabled (before, it would set
                    the screen-value to "0").  Some foreign
                    character fields use this field to store length info, and
                    it was being overwritten if/when the "save" button was
                    pressed.  Also, this change makes it consistent with the
                    TTY dictionary.

----------------------------------------------------------------------------*/

&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/adestds.i} 

{adedict/dictvar.i shared}
{adecomm/cbvar.i shared}
{adedict/uivar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/capab.i}

Define INPUT PARAMETER p_Case as widget-handle NO-UNDO.
Define INPUT PARAMETER p_Dec  as widget-handle NO-UNDO.

assign
   p_Case:sensitive = (if s_Fld_Typecode = {&DTYPE_CHARACTER} AND
      	       	       INDEX(s_Fld_Capab, {&CAPAB_CHANGE_CASE_SENS}) > 0 AND
      	       	       (s_Adding OR NOT s_Fld_InIndex)
      	       	      then yes else no)
   p_Dec:sensitive = (if s_Fld_Typecode = {&DTYPE_DECIMAL} OR
      	       	      s_Fld_Gatetype = "Bits" then yes else no)
   p_Dec:label = (if s_Fld_Gatetype = "Bits" then "Bit Off&set" 
      	       	     	      	       	     else "Decimal&s").

if p_Case:sensitive = no then
   p_Case:screen-value = "no".
if p_Dec:sensitive = no then
   p_Dec:screen-value = /*"0"*/ ?.







