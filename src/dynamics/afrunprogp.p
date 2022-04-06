/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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



