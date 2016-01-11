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
/*
 * _conndb.p - Connect to DataServers
 */

DEFINE VARIABLE arg_db      AS CHARACTER NO-UNDO. /* physical db-name  */
DEFINE VARIABLE arg_ld      AS CHARACTER NO-UNDO. /* logical db-name   */
DEFINE VARIABLE arg_dt      AS CHARACTER NO-UNDO. /* db-type           */
DEFINE VARIABLE arg_1       AS LOGICAL   NO-UNDO. /* multi-user ?      */
DEFINE VARIABLE arg_network AS CHARACTER NO-UNDO. /* network type (-N) */
DEFINE VARIABLE arg_host    AS CHARACTER NO-UNDO. /* host name (-H)    */
DEFINE VARIABLE arg_service AS CHARACTER NO-UNDO. /* service name (-S) */
DEFINE VARIABLE arg_u       AS CHARACTER NO-UNDO. /* user-id           */
DEFINE VARIABLE arg_p       AS CHARACTER NO-UNDO. /* password          */
DEFINE VARIABLE arg_tl      AS CHARACTER NO-UNDO. /* trigger-file-name */
DEFINE VARIABLE arg_pf      AS CHARACTER NO-UNDO. /* parameter-file    */
DEFINE VARIABLE args        AS CHARACTER NO-UNDO EXTENT 4.
DEFINE VARIABLE qbf-l       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE stri        AS CHARACTER NO-UNDO.

/* Give user chance to connect to foreign databases not already connected */
FOR EACH RESULTSDB._Db NO-LOCK:
  IF RESULTSDB._Db._Db-Name = "z_ora_links":u THEN NEXT.

  IF NOT CONNECTED(RESULTSDB._Db._Db-Name) THEN DO:
    ASSIGN
      arg_db = RESULTSDB._Db._Db-Name
      arg_ld = RESULTSDB._Db._Db-Name
      arg_dt = RESULTSDB._Db._Db-Type.

    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"question":u,"yes-no":u,
      SUBSTITUTE("In order to access data in database &1 it must be connected.  Do you want to connect now?",
      arg_db)).

   IF qbf-l THEN DO:
     /* get connect parameters */
     RUN adecomm/_getconp.p (INPUT        arg_db,
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
        
     /* connect to foreign database */ 
     RUN adecomm/_dbconnx.p (INPUT        yes,
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
   END.
  END.
END.

/* _conndb.p - end of file */

