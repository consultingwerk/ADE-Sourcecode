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

File: dtwidth.i

Description:
   For gateways, the data type list is multi-column so we need to
   use fixed font in order to line up the columns.  This makes
   the string wider so we need to make the data type fill-in and
   list wider (especially for proportional spaced font).

Arguments:
   &Frame = name of frame, e.g., "Frame newfld"
   &Only1 = true if there will be no data type list (e.g. for properties
      	    when you can't change the type).

Author: Laura Stern

Date Created: 08/20/93 

----------------------------------------------------------------------------*/

if IsPro OR {&Only1} then 
   assign
      s_Fld_DType:font 	    in {&Frame} = ?
      s_lst_Fld_DType:font  in {&Frame} = ?
      s_Fld_DType:width     in {&Frame} = b_Field._Field-name:width in {&Frame} 
      s_lst_Fld_DType:width in {&Frame} = b_Field._Field-name:width in {&Frame}.
else
   assign
      s_Fld_DType:font 	    in {&Frame} = 0
      s_lst_Fld_DType:font  in {&Frame} = 0
      s_Fld_DType:width     in {&Frame} = 40
      s_lst_Fld_DType:width in {&Frame} = 40.
