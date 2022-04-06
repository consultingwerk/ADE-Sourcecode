/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
    Modified: 05/19/99 Mario B.  Adjust Width Field browser integration.
              05/28/99 Mario B.  Added call to _closqlw.p.
----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}

Define INPUT PARAMETER p_Db as logical NO-UNDO.

if p_Db then
   if s_win_Db <> ? then
   do:
      {adedict/delwin.i &Win = s_win_Db &Obj = {&OBJ_DB}}
   end.

if s_win_Tbl <> ? then
do:
   {adedict/delwin.i &Win = s_win_Tbl &Obj = {&OBJ_TBL}}
end.

if s_win_Seq <> ? then
do:
   {adedict/delwin.i &Win = s_win_Seq &Obj = {&OBJ_SEQ}}
end.

if s_win_Fld <> ? then
do:
   {adedict/delwin.i &Win = s_win_Fld &Obj = {&OBJ_FLD}}
end.

if s_win_Idx <> ? then
do:
   {adedict/delwin.i &Win = s_win_Idx &Obj = {&OBJ_IDX}}
end.

IF s_win_Width <> ? THEN
DO:
   RUN prodict/gui/_closqlw.p.
   {adedict/delwin.i &Win = s_win_Width &Obj = {&OBJ_WIDTH}}
END.

/* Menu graying needs to be run because of SQL Width Browse */
RUN adedict/_brwgray.p (INPUT NO). 
