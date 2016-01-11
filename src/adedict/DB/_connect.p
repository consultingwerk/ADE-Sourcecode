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
95-04-17    j.palazzo   added network, host, and service params to
                          _getconp.p call.
94-07-29    hutegger    changed arg_ld from ? to ldbname(p_name)
94-05-02    hutegger    changed the code to use _getconp.p

----------------------------------------------------------------------------*/

{adedict/dictvar.i SHARED}
{adedict/brwvar.i SHARED}

DEFINE INPUT  PARAMETER p_name  AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cnt 	    AS INTEGER 	 NO-UNDO.
DEFINE VARIABLE dblst       AS HANDLE    NO-UNDO.

DEFINE VARIABLE arg_1       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE arg_db      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_dt      AS CHARACTER NO-UNDO INITIAL "PROGRESS".
DEFINE VARIABLE arg_ld      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_p       AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_pf      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_u       AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_tl      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_network AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_host    AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_service AS CHARACTER NO-UNDO.
DEFINE VARIABLE ix          AS INTEGER   NO-UNDO.
DEFINE VARIABLE stri        AS CHARACTER NO-UNDO.
DEFINE VARIABLE args        AS CHARACTER NO-UNDO EXTENT 4.

/*----------------------------Mainline code----------------------------------*/

ASSIGN
  arg_db         = p_Name
  arg_ld         = LDBNAME(p_name)
  arg_dt         = DBTYPE(p_Name)
  CURRENT-WINDOW = (IF s_win_Logo = ? THEN s_win_Browse ELSE s_win_Logo).

IF arg_db <> ? AND NUM-DBS > 0 THEN
  RUN prodict/misc/_getconp.p (INPUT        arg_db,
                               INPUT-OUTPUT arg_db,
                               INPUT-OUTPUT arg_ld,
                               INPUT-OUTPUT arg_dt,
                               OUTPUT       arg_tl,
                               OUTPUT       arg_pf,
                               OUTPUT       arg_1,
                               OUTPUT       arg_network,
                               OUTPUT       arg_host,
                               OUTPUT       arg_service,
                               OUTPUT       arg_u,
                               OUTPUT       arg_p,
                               OUTPUT       args[2],
                               OUTPUT       args[3],
                               OUTPUT       args[4]).

ASSIGN args[2] = args[2] + " " + args[3] + " " + args[4].

RUN adecomm/_dbconnx.p (INPUT        YES,
                        INPUT-OUTPUT arg_db,
                        INPUT-OUTPUT arg_ld,
                        INPUT-OUTPUT arg_dt,
                        INPUT-OUTPUT arg_1,
                        INPUT-OUTPUT arg_network,
                        INPUT-OUTPUT arg_host,
                        INPUT-OUTPUT arg_service,
                        INPUT-OUTPUT arg_u,
                        INPUT-OUTPUT arg_p,
                        INPUT-OUTPUT arg_tl,
                        INPUT-OUTPUT arg_pf,
                        INPUT-OUTPUT args[2],
                        OUTPUT       stri).

IF arg_ld <> ? THEN DO: /* connect succeeded */
  /* If the user connected to other databases via the unix parms, this
     will add them to the list as well. */
  cnt = s_DbCache_Cnt.  /* remember how many we have now */

  RUN adedict/DB/_getdbs.p.

  /* Make sure we actually add something to the list.  If all dbs were
     V5 e.g., we wouldn't have. */
  dblst = s_lst_Dbs:HANDLE IN FRAME BROWSE.  /* for convenience */
  IF s_DbCache_Cnt > cnt THEN DO:
    ASSIGN
      arg_ld             = dblst:ENTRY(cnt + 1)
      dblst:SCREEN-VALUE = arg_ld.

    RUN adecomm/_scroll.p (dblst,arg_ld).

    /* This will cause wait-for to break and switch to the new database
       as soon as we leave here (i.e., leave the trigger that invoked
       _connect.p.).  */
    APPLY "VALUE-CHANGED":u TO dblst.
  END.
END.

/* _connect.p - end of file */

