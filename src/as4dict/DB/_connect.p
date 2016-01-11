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

File: _connect.p

Description:
   Display and handle the connect dialog box.  Most of this code has been
   put into a common dialog service so that it is useable from outside the
   dictionary.

Input Parameter:
   p_name - The default physical name of the database to connect to, or ?.

Author: Laura Stern

Date Created: 03/03/92 

history
    94-07-29    hutegger    changed arg_ld from ? to ldbname(p_name)
    94-05-02    hutegger    changed the code to use _getconp.p
    
----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}

Define INPUT  PARAMETER p_name  as char    NO-UNDO.


Define var cnt 	    as integer 	       NO-UNDO.
Define var dblst    as widget-handle   NO-UNDO.

DEFINE VARIABLE arg_1  AS LOGICAL   INITIAL FALSE      NO-UNDO.
DEFINE VARIABLE arg_db AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE arg_dt AS CHARACTER INITIAL "PROGRESS" NO-UNDO.
DEFINE VARIABLE arg_ld AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE arg_p  AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE arg_pf AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE arg_u  AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE arg_tl AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE ix     AS INTEGER                      NO-UNDO.
DEFINE VARIABLE stri   AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE args   AS CHARACTER EXTENT 4  NO-UNDO.


/*----------------------------Mainline code----------------------------------*/

     
ASSIGN
  arg_db = p_Name
  arg_ld = ldbname(p_name)
  arg_dt = dbtype(p_Name).
  current-window = (if s_win_Logo = ? then s_win_Browse else s_win_Logo).
if   arg_db <> ?
 AND num-dbs > 0
 then run "prodict/misc/_getconp.p"
      ( INPUT        arg_db,
        INPUT-OUTPUT arg_db,
        INPUT-OUTPUT arg_ld,
        INPUT-OUTPUT arg_dt,
        OUTPUT       arg_tl,
        OUTPUT       arg_pf,
        OUTPUT       arg_1,
        OUTPUT       arg_u,
        OUTPUT       arg_p,
        OUTPUT       args[2],
        OUTPUT       args[3],
        OUTPUT       args[4]
        ).
assign args[2] = args[2] + " " + args[3] + " " + args[4].
run adecomm/_dbconnx.p 
     ( INPUT        yes,
       INPUT-OUTPUT arg_db,
       INPUT-OUTPUT arg_ld,
       INPUT-OUTPUT arg_dt,
       INPUT-OUTPUT arg_1,
       INPUT-OUTPUT arg_u,
       INPUT-OUTPUT arg_p,
       INPUT-OUTPUT arg_tl,
       INPUT-OUTPUT arg_pf,
       INPUT-OUTPUT args[2],
       OUTPUT       stri
       ).

if arg_ld <> ? then  /* connect succeeded */
do:
   /* If the user connected to other databases via the unix parms, this
      will add them to the list as well. */
   cnt = s_DbCache_Cnt.  /* remember how many we have now */
   run as4dict/db/_getdbs.p.

   /* Make sure we actually add something to the list.  If all dbs were
      V5 e.g., we wouldn't have. */
   dblst = s_lst_Dbs:HANDLE in frame browse.  /* for convenience */
   if s_DbCache_Cnt > cnt then
   do:
      assign
      	 arg_ld = dblst:ENTRY(cnt + 1)
      	 dblst:screen-value = arg_ld.

      run adecomm/_scroll.p (INPUT dblst, INPUT arg_ld).

      /* This will cause wait-for to break and switch to the new database 
      	 as soon as we leave here (i.e., leave the trigger that invoked 
      	 _connect.p.).
      */
      apply "value-changed" to dblst.
   end.
end.


