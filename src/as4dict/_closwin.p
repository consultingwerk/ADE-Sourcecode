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
           Modified to work with PROGRESS/400 Data Dictionary   D. McMann
           04/29/99 D. McMann Added Stored Procedure Support
----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/uivar.i shared}
{adecomm/cbvar.i shared}

{as4dict/DB/dbvar.i shared}
{as4dict/TBL/tblvar.i shared}
{as4dict/SEQ/seqvar.i shared}
{as4dict/FLD/fldvar.i shared}
{as4dict/IDX/idxvar.i shared}
{as4dict/prc/procvar.i shared}
{as4dict/parm/parmvar.i shared }

case (SELF):
   when s_win_Db then do:
      {as4dict/delwin.i &Win = s_win_Db &Obj = {&OBJ_DB}}
   end.
   when s_win_Tbl then do:
      {as4dict/delwin.i &Win = s_win_Tbl &Obj = {&OBJ_TBL}}
   end.
   when s_win_Seq then do:
      {as4dict/delwin.i &Win = s_win_Seq &Obj = {&OBJ_SEQ}}
   end.
   when s_win_Fld then do:
      {as4dict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
   end.
   when s_win_Idx then do:
      {as4dict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
   end.
    when s_win_Proc then do:
      {as4dict/delwin.i &Win = s_win_Proc &Obj = {&OBJ_PROC}}
   end.
   when s_win_Parm then do:
      {as4dict/delwin.i &Win = s_win_Parm &Obj = {&OBJ_PARM}}
   end.

end.

return ERROR.

