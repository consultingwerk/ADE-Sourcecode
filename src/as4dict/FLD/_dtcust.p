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

----------------------------------------------------------------------------*/

{adecomm/adestds.i} 

{as4dict/dictvar.i shared}
{adecomm/cbvar.i shared}
{as4dict/uivar.i shared}
{as4dict/FLD/fldvar.i shared}
{as4dict/capab.i}

Define INPUT PARAMETER p_Dec  as widget-handle NO-UNDO.

assign
   p_Dec:sensitive =   NO 
   p_Dec:label = (if s_Fld_Gatetype = "Bits" then "Bit offset" 
      	       	     	      	       	     else "Decima&ls").






