/***********************************************************************
* Copyright (C) 2000,2010 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/


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

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}


Define INPUT PARAMETER p_Name  as char 	  NO-UNDO.
Define INPUT PARAMETER p_Order as integer NO-UNDO.

Define var ins_name as char    NO-UNDO.

if s_Order_By = {&ORDER_ALPHA} then
   find FIRST dictdb._Field where dictdb._Field._File-recid = s_TblRecId 
                              AND dictdb._Field._Field-Name > p_Name
      NO-ERROR.
else
   find FIRST dictdb._Field where dictdb._Field._File-recid = s_TblRecId 
                              AND dictdb._Field._Order > p_Order
      NO-ERROR.

ins_name = (if AVAILABLE dictdb._Field then dictdb._Field._Field-name else "").

/* if create button pushed that caused blob, clob, or xlob procedure to run
   we don't want to put in list twice */
IF s_lst_flds:LOOKUP(p_name) = 0 THEN
  run adedict/_newobj.p 
    (INPUT s_lst_Flds:HANDLE in frame browse,
     INPUT p_Name,
     INPUT ins_name,
     INPUT s_Flds_Cached,
     INPUT {&OBJ_FLD}).
