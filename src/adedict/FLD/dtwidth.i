/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
