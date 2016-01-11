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

SESSION:TIME-SOURCE = LDBNAME(1) NO-ERROR.

/* &IF "{&scmTool}" = "RTB":U */
define new global shared variable grtb-wsroot as character no-undo.
define new global shared variable grtb-wspace-id as character no-undo.
define new global shared variable grtb-task-num as integer no-undo.
define new global shared variable grtb-propath as character no-undo.
define new global shared variable grtb-userid as character no-undo.
define new global shared variable grtb-access as character no-undo.

DEFINE VARIABLE lv_result AS LOGICAL NO-UNDO.

IF NUM-ENTRIES(SESSION:PARAM,"*":U) >= 2
THEN DO:

    SESSION:SET-WAIT-STATE('general':U).
    IF (SEARCH("astraload.p":U) <> ?
    OR SEARCH("astraload.p":U) <> ?)
    THEN
      RUN astraload.p (ENTRY(2,SESSION:PARAM,"*":U)).

    ASSIGN
        lv_result = RETURN-VALUE = "":U OR RETURN-VALUE = ?.

    SESSION:SET-WAIT-STATE('':U).

END.
ELSE
    ASSIGN
        lv_result = YES.

IF lv_result THEN DO:
  RUN-BLOCK:
  DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:
    IF SESSION:SET-WAIT-STATE('general':U) THEN PROCESS EVENTS.
    RUN VALUE(ENTRY(1,SESSION:PARAM,"*":U)).
  END.
END.  
IF SESSION:SET-WAIT-STATE('':U) THEN PROCESS EVENTS.


IF CONNECTED("RTB":U)
AND SESSION:PARAM <> "":U
THEN
  DISCONNECT RTB NO-ERROR.

IF CONNECTED("RTB")
THEN 
  RETURN.
ELSE
  QUIT.



