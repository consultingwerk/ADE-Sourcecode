
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
{adedict/IDX/idxvar.i shared}

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

