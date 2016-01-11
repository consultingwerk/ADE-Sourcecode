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

File: _ptinlst.p

Description:
   Put the new field or existing field whose name or order # has changed
   into the browse select list in the correct position.

Input Parameters:
   p_Name  - The name of the new or modified field
   p_Order - The new or modified order# for this field.

Author: Laura Stern

Date Created: 12/01/92 

----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}


Define INPUT PARAMETER p_Name  as char 	  NO-UNDO.
Define INPUT PARAMETER p_Order as integer NO-UNDO.

Define var ins_name as char    NO-UNDO.


if s_Order_By = {&ORDER_ALPHA} then
   find FIRST as4dict.p__Field where as4dict.p__Field._File-number = s_TblForNo AND
	     	      	   as4dict.p__Field._Field-Name > p_Name
      NO-ERROR.
else
   find FIRST as4dict.p__Field where as4dict.p__Field._File-number = s_TblForNo AND
	     	      	    as4dict.p__Field._Order > p_Order
      NO-ERROR.

ins_name = (if AVAILABLE as4dict.p__Field then as4dict.p__Field._Field-name else "").
run as4dict/_newobj.p 
   (INPUT s_lst_Flds:HANDLE in frame browse,
    INPUT p_Name,
    INPUT ins_name,
    INPUT s_Flds_Cached,
    INPUT {&OBJ_FLD}).
