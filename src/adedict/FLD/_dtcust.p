/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
    D. McMann 06/09/03 Added data type CLOB to check for case sensitivity

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
   p_Case:sensitive = (if (s_Fld_Typecode = {&DTYPE_CHARACTER} OR s_Fld_Typecode = {&DTYPE_CLOB} )
                       AND INDEX(s_Fld_Capab, {&CAPAB_CHANGE_CASE_SENS}) > 0 AND
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







