/**************************************************************************
Copyright (c) 2023-2024 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/**
 * Author(s): Dustin Grau (dugrau@progress.com)
 *
 * Stops (terminates) all running MSAgents of an ABLApp.
 * Usage: stopAgents.p <params>
 *  Parameter Default/Allowed
 *   Scheme     [http|https]
 *   Hostname   [localhost]
 *   PAS Port   [8810]
 *   UserId     [tomcat]
 *   Password   [tomcat]
 *   ABL App    [oepas1]
 *   WaitFinish [120000]
 *   WaitAfter  [60000]
 */

using OpenEdge.ApplicationServer.Util.OEManagerConnection.
using OpenEdge.ApplicationServer.Util.OEManagerEndpoint.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.JsonDataTypeEnum.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.

define variable oAgents     as JsonArray  no-undo.
define variable oAgent      as JsonObject no-undo.
define variable oStacks     as JsonArray  no-undo.
define variable iLoop       as integer    no-undo.
define variable cOutFile    as character  no-undo.
define variable cPID        as character  no-undo.
define variable cProcID     as character  no-undo.
define variable cWaitAfter  as character  no-undo initial "60000".
define variable cWaitFinish as character  no-undo initial "120000".

/* Manage the server connection to the OEManager webapp */
define variable oMgrConn  as OEManagerConnection no-undo.
define variable cScheme   as character           no-undo initial "http".
define variable cHost     as character           no-undo initial "localhost".
define variable cPort     as character           no-undo.
define variable cUserId   as character           no-undo.
define variable cPassword as character           no-undo.
define variable cAblApp   as character           no-undo.

/* Check for passed-in arguments/parameters. */
if num-entries(session:parameter) ge 9 then
    assign
        cScheme     = entry(1, session:parameter)
        cHost       = entry(2, session:parameter)
        cPort       = entry(3, session:parameter)
        cUserId     = entry(4, session:parameter)
        cPassword   = entry(5, session:parameter)
        cAblApp     = entry(6, session:parameter)
        cWaitFinish = entry(7, session:parameter)
        cWaitAfter  = entry(8, session:parameter)
        cProcID     = entry(9, session:parameter)
        .
else
    assign
        cScheme     = dynamic-function("getParameter" in source-procedure, "Scheme") when (dynamic-function("getParameter" in source-procedure, "Scheme") gt "") eq true
        cHost       = dynamic-function("getParameter" in source-procedure, "Host") when (dynamic-function("getParameter" in source-procedure, "Host") gt "") eq true
        cPort       = dynamic-function("getParameter" in source-procedure, "Port") when (dynamic-function("getParameter" in source-procedure, "Port") gt "") eq true
        cUserId     = dynamic-function("getParameter" in source-procedure, "UserID") when (dynamic-function("getParameter" in source-procedure, "UserID") gt "") eq true
        cPassword   = dynamic-function("getParameter" in source-procedure, "PassWD") when (dynamic-function("getParameter" in source-procedure, "PassWD") gt "") eq true
        cAblApp     = dynamic-function("getParameter" in source-procedure, "ABLApp") when (dynamic-function("getParameter" in source-procedure, "ABLApp") gt "") eq true
        cWaitFinish = dynamic-function("getParameter" in source-procedure, "WaitFinish") when (dynamic-function("getParameter" in source-procedure, "WaitFinish") gt "") eq true
        cWaitAfter  = dynamic-function("getParameter" in source-procedure, "WaitAfter") when (dynamic-function("getParameter" in source-procedure, "WaitAfter") gt "") eq true
        cProcID     = dynamic-function("getParameter" in source-procedure, "ProcID") when (dynamic-function("getParameter" in source-procedure, "ProcID") gt "") eq true
        .

/* Create and OEManager connection for API calls. */
assign oMgrConn = OEManagerConnection:Build(cScheme, cHost, integer(cPort), cUserId, cPassword).

/* PROCEDURES / FUNCTIONS */

/* Output the name of the program being executed. */
oMgrConn:LogCommand("RUN", this-procedure:name).

/* Initial URL to obtain a list of all MSAgents for an ABL Application. */
message substitute("Looking for MSAgents of &1...", cAblApp).
assign oAgents = oMgrConn:GetAgents(cAblApp).

if oAgents:Length eq 0 then
    message "No MSAgents running".
else
AGENTBLK:
do iLoop = 1 to oAgents:Length
on error undo, next AGENTBLK
on stop undo, next AGENTBLK:
    oAgent = oAgents:GetJsonObject(iLoop).

    /* We need the agent PID for user-friendly displays since that's how we identify the process. */
    if JsonPropertyHelper:HasTypedProperty(oAgent, "pid", JsonDataType:string) then
        assign cPID = oAgent:GetCharacter("pid").

    /* If given a distinct Process ID to terminate, skip to the next agent if this does not match. */
    if (cProcID gt "") eq true and cPID ne cProcID then next AGENTBLK.

    /* Write session stack information for any available MSAgents. */
    if oAgent:GetCharacter("state") eq "available" then do:
        assign oStacks = oMgrConn:GetAgentStacks(cAblApp, integer(cPID)).
        if oStacks:Length gt 0 then do:
            message substitute("Saving stack information for MSAgent PID &1...", cPID).
            assign cOutFile = substitute("agentStacks_&1_&2.json", cPID, replace(iso-date(now), ":", "_")).
            oStacks:WriteFile(session:temp-directory + cOutFile, true). /* Write entire response to disk. */
            message substitute("~tStack data written to &1", cOutFile).
        end.
        else
            message substitute("No stack data for MSAgent PID &1", cPID).
    end. /* agent state = available */
    else
        message substitute("MSAgent PID &1 not AVAILABLE, skipping stacks.", cPID).

    /* Gracefully stop each MSAgent through use of the waitToFinish and waitAfterStop timeout values. */
    do stop-after 10
    on error undo, throw
    on stop undo, retry:
        if retry then
            undo, throw new Progress.Lang.AppError("Encountered a stop condition", 0).

        /* Note: For security reasons, we use the internal AgentID to identify the MSAgent to be stopped. */
        message substitute("Stopping MSAgent PID &1...", cPID).
        message oMgrConn:GetOpOutcome(oMgrConn:StopAgent(cAblApp, oAgent:GetCharacter("agentId"), cWaitFinish, cWaitAfter)).

        catch err as Progress.Lang.Error:
            message substitute("Error Stopping PID &1: &2", cPID, err:GetMessage(1)).
            next AGENTBLK.
        end catch.
    end. /* do stop-after */
end. /* iLoop - agent */

catch err as Progress.Lang.Error:
    put unformatted substitute("~nError while communicating with PASOE instance: &1", err:GetMessage(1)) skip.
end catch.
finally:
    /* Return value expected by PCT Ant task. */
    {&_proparse_ prolint-nowarn(returnfinally)}
    return string(0).
end finally.
