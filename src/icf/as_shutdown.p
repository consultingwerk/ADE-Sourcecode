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
/* as_shutdown.p */

/* pull in Astra global variables as new global */
{af/sup2/afglobals.i NEW GLOBAL}

/* Shutdown any and all managers running. These shutdown in reverse order of starting. */
IF VALID-HANDLE(gshAgnManager)          THEN APPLY "CLOSE":U TO gshAgnManager.
IF VALID-HANDLE(gshFinManager)          THEN APPLY "CLOSE":U TO gshFinManager.
IF VALID-HANDLE(gshGenManager)          THEN APPLY "CLOSE":U TO gshGenManager.
IF VALID-HANDLE(gshTranslationManager)  THEN APPLY "CLOSE":U TO gshTranslationManager.
IF VALID-HANDLE(gshRepositoryManager)   THEN APPLY "CLOSE":U TO gshRepositoryManager.
IF VALID-HANDLE(gshProfileManager)      THEN APPLY "close":U TO gshProfileManager.
IF VALID-HANDLE(gshSecurityManager)     THEN APPLY "close":U TO gshSecurityManager.
IF VALID-HANDLE(gshSessionManager)      THEN APPLY "close":U TO gshSessionManager.

ASSIGN gshAgnManager         = ?
       gshFinManager         = ?
       gshGenManager         = ?
       gshTranslationManager = ?
       gshRepositoryManager  = ?
       gshProfileManager     = ?
       gshSecurityManager    = ?
       gshSessionManager     = ?
       gshAstraAppserver     = ?
       gscSessionId          = ?
       .

DEFINE VARIABLE hLoopHandle AS HANDLE     NO-UNDO.
DEFINE VARIABLE hConfMan    AS HANDLE     NO-UNDO.

hLoopHandle = SESSION:FIRST-PROCEDURE.
DO WHILE VALID-HANDLE(hLoopHandle):
  IF R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.p":U) > 0
  OR R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.r":U) > 0 THEN 
  DO:
    hConfMan = hLoopHandle.
    hLoopHandle = ?.
  END.
  ELSE
    hLoopHandle = hLoopHandle:NEXT-SIBLING.
END. /* VALID-HANDLE(hLoopHandle) */

IF VALID-HANDLE(hConfMan) THEN
  RUN killPlip IN hConfMan.
