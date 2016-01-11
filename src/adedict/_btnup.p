/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _btnup.p

Description:
   Toggle whichever one of the browse window "show object" buttons is pushed 
   in to be un-pushed.  This means bring the "up" button to the top of 
   the z order stack so that this is the one users see.

Author: Laura Stern

Date Created: 09/22/92 

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}
{adedict/brwvar.i shared}

case s_CurrObj:
   when {&OBJ_DB} then
      s_Res = s_Icn_Dbs:LOAD-IMAGE("adeicon/db-u").
   when {&OBJ_TBL} then
      s_Res = s_Icn_Tbls:LOAD-IMAGE("adeicon/table-u").
   when {&OBJ_SEQ} then
      s_Res = s_Icn_Seqs:LOAD-IMAGE("adeicon/seq-u").
   when {&OBJ_FLD} then
      s_Res = s_Icn_Flds:LOAD-IMAGE("adeicon/flds-u").
   when {&OBJ_IDX} then
      s_Res = s_Icn_Idxs:LOAD-IMAGE("adeicon/index-u").
end.


