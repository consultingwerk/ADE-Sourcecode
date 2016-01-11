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
/* procedure to test appserver connection */

{src/adm2/globals.i}

DEFINE OUTPUT PARAMETER plRemote   AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pcConnid   AS CHARACTER NO-UNDO. /* SESSION:SERVER-CONNECTION-ID */
DEFINE OUTPUT PARAMETER pcOpmode   AS CHARACTER NO-UNDO. /* SESSION:SERVER-OPERATING-MODE */
DEFINE OUTPUT PARAMETER plConnReq  AS LOGICAL   NO-UNDO. /* SESSION:SERVER-CONNECTION-BOUND-REQUEST */
DEFINE OUTPUT PARAMETER plConnbnd  AS LOGICAL   NO-UNDO. /* SESSION:SERVER-CONNECTION-BOUND */
DEFINE OUTPUT PARAMETER pcConnctxt AS CHARACTER NO-UNDO. /* SESSION:SERVER-CONNECTION-CONTEXT */
DEFINE OUTPUT PARAMETER pcASppath  AS CHARACTER NO-UNDO. /* PROPATH */
DEFINE OUTPUT PARAMETER pcConndbs  AS CHARACTER NO-UNDO. /* List of Databases */
DEFINE OUTPUT PARAMETER pcConnpps  AS CHARACTER NO-UNDO. /* List of Running Persistent Procedures */
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTTParam.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTTManager.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTTServiceType.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phTTService.

DEFINE VARIABLE iLoop              AS INTEGER   NO-UNDO. /* Generic counter */
DEFINE VARIABLE hAS                AS HANDLE    NO-UNDO. /* AppServer connection handle */
DEFINE VARIABLE cDBList            AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDBVersions        AS CHARACTER NO-UNDO.

ASSIGN
  plRemote   = SESSION:REMOTE
  pcConnid   = SESSION:SERVER-CONNECTION-ID
  pcOpmode   = SESSION:SERVER-OPERATING-MODE
  plConnReq  = SESSION:SERVER-CONNECTION-BOUND-REQUEST
  plConnbnd  = SESSION:SERVER-CONNECTION-BOUND
  pcConnctxt = SESSION:SERVER-CONNECTION-CONTEXT
  pcASppath   = PROPATH
  .

/* Generate list of connected databases */
ASSIGN cDBList = "":U.
DO iLoop = 1 TO NUM-DBS:
  ASSIGN cDBList = cDBList + (IF cDBList <> "":U THEN ",":U ELSE "":U) + LDBNAME(iLoop).
END.         
IF cDBList <> "":U AND VALID-HANDLE(gshGenManager) THEN
  RUN getDBVersion IN gshGenManager (INPUT cDBList, OUTPUT cDBVersions).


IF NUM-DBS > 0 THEN 
DO iLoop = 1 TO NUM-DBS:
  ASSIGN pcConndbs = pcConndbs + (IF pcConndbs NE "" THEN ",":U ELSE "") + LDBNAME(iLoop) + " (":U + PDBNAME(iLoop) + ")":U.
  IF cDBVersions <> "":U THEN
    ASSIGN pcConndbs = pcConndbs + " (Delta: ":U + ENTRY(iLoop, cDBVersions) + ")":U.
END.

/* Generate a list of running persistent procedures */
hAS = SESSION:FIRST-PROCEDURE.
DO WHILE hAS <> ?:
  IF hAS:PERSISTENT THEN
    ASSIGN pcConnpps = pcConnpps + (IF pcConnpps NE "" THEN ",":U ELSE "") + hAS:FILE-NAME.
  hAS = hAS:NEXT-SIBLING.
END.

/* Get the connections and config manager temp-tables */
RUN obtainCFMTables        IN THIS-PROCEDURE ( OUTPUT phTTParam, OUTPUT phTTManager).
RUN obtainConnectionTables IN THIS-PROCEDURE ( OUTPUT phTTServiceType, OUTPUT phTTService).

RETURN.
