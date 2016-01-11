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

File: _delwins.p

Description:
   Delete any open edit windows.

Input Parameter:
   p_Db - Set to yes to include the DB window in the set of windows to
      	  close.
 
Author: Laura Stern

Date Created: 04/24/92 
           Modified to work with PROGRESS/400 Data Dictionary   D. McMann
----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}

Define INPUT PARAMETER p_Db as logical NO-UNDO.

if p_Db then
   if s_win_Db <> ? then
   do:
      {as4dict/delwin.i &Win = s_win_Db &Obj = {&OBJ_DB}}
   end.

if s_win_Tbl <> ? then
do:
   {as4dict/delwin.i &Win = s_win_Tbl &Obj = {&OBJ_TBL}}
end.

if s_win_Seq <> ? then
do:
   {as4dict/delwin.i &Win = s_win_Seq &Obj = {&OBJ_SEQ}}
end.

if s_win_Fld <> ? then
do:
   {as4dict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
end.

if s_win_Idx <> ? then
do:
   {as4dict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
end.



