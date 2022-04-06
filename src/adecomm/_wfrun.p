/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _wfrun.p
                                       
    Purpose:    Checks to see if another tool is already 'run'ning a 
                procedure. If so, return error. If not, set global var
                called wfRunning to the tools name.
                
                Performs same check to TRANSACTION.

    Syntax :    RUN adecomm/_wfrun.p ( INPUT toolname , OUTPUT rcode ).

    Parameters:
        toolname : Name of calling ADE tool
        rcode    : return code (is something else running?)
    Description:
    Notes  :
    Authors: Gerry Seidl
    Date   : 12/16/94
**************************************************************************/
DEFINE NEW GLOBAL SHARED VARIABLE wfRunning     AS CHARACTER NO-UNDO.

DEFINE INPUT  PARAMETER toolname   AS CHARACTER              NO-UNDO.
DEFINE OUTPUT PARAMETER rcode      AS LOGICAL   INITIAL YES  NO-UNDO.

DEFINE VARIABLE tool_running       AS LOGICAL                NO-UNDO.
DEFINE VARIABLE tool_name          AS CHARACTER              NO-UNDO.

ASSIGN tool_running = (wfRunning <> "" AND wfRunning <> toolname).
IF tool_running OR TRANSACTION THEN
DO:
    ASSIGN tool_name = wfRunning.
    ASSIGN tool_name = ENTRY(1, tool_name) NO-ERROR.
    IF tool_running THEN
    MESSAGE "Cannot run." tool_name "is already running application code."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW ACTIVE-WINDOW.
    ELSE
    MESSAGE "Cannot run. A transaction is currently active."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW ACTIVE-WINDOW.
    ASSIGN rcode = YES.
END.
ELSE
    ASSIGN wfRunning = toolname
           rcode     = NO.
