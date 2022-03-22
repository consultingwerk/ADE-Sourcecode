
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _closwin.p

Description:
   Close the current edit window.
 
Author: Laura Stern

Date Created: 04/24/92
    Modified: 05/19/99 Mario B.  Adjust Width Field browser integration.
              05/28/99 Mario B.  Added call to _closqlw.p.
    
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adecomm/cbvar.i shared}

{adedict/DB/dbvar.i shared}
{adedict/TBL/tblvar.i shared}
{adedict/SEQ/seqvar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/IDX/idxvar2.i shared}
 
case (SELF):
   when s_win_Db then do:
      {adedict/delwin.i &Win = s_win_Db &Obj = {&OBJ_DB}}
   end.
   when s_win_Tbl then do:
      {adedict/delwin.i &Win = s_win_Tbl &Obj = {&OBJ_TBL}}
      RUN adedict/_brwgray.p (INPUT NO).       
   end.   
   when s_win_Seq then do:
      {adedict/delwin.i &Win = s_win_Seq &Obj = {&OBJ_SEQ}}
   end.
   when s_win_Fld then do:
      {adedict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
      RUN adedict/_brwgray.p (INPUT NO).      
   end.
   when s_win_Idx then do:
      {adedict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
   end.
   when s_win_Width then do:
      RUN prodict/gui/_closqlw.p.
      {adedict/delwin.i &Win = s_win_Width &Obj = {&OBJ_WIDTH}}
      RUN adedict/_brwgray.p (INPUT NO).
   end.

end.

return ERROR.

