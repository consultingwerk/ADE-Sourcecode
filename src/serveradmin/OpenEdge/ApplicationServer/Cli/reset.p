/**************************************************************************
Copyright (c) 2023-2024 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/**
 * Author(s): Dustin Grau (dugrau@progress.com)
 *
 * Resets an aspect of running MSAgents of an ABLApp.
 * Usage: reset.p <params>
 *  Parameter Default/Allowed
 *   Scheme     [http|https]
 *   Hostname   [localhost]
 *   PAS Port   [8810]
 *   UserId     [tomcat]
 *   Password   [tomcat]
 *   ABL App    [oepas1]
 *   Type       [stats|logs]
 *
 * Based on https://knowledgebase.progress.com/articles/Article/dbi-from-pas-agent-keeps-growing
 */

using OpenEdge.ApplicationServer.Util.OEManagerConnection.
using OpenEdge.ApplicationServer.Util.OEManagerEndpoint.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.JsonDataTypeEnum.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.

define variable oAgents  as JsonArray  no-undo.
define variable oAgent   as JsonObject no-undo.
define variable iLoop    as integer    no-undo.
define variable cPID     as character  no-undo.
define variable cType    as character  no-undo initial "stats".

/* Manage the server connection to the OEManager webapp */
define variable oMgrConn  as OEManagerConnection no-undo.
define variable cScheme   as character           no-undo initial "http".
define variable cHost     as character           no-undo initial "localhost".
define variable cPort     as character           no-undo.
define variable cUserId   as character           no-undo.
define variable cPassword as character           no-undo.
define variable cAblApp   as character           no-undo.

/* Check for passed-in arguments/parameters. */
if num-entries(session:parameter) ge 7 then
    assign
        cScheme   = entry(1, session:parameter)
        cHost     = entry(2, session:parameter)
        cPort     = entry(3, session:parameter)
        cUserId   = entry(4, session:parameter)
        cPassword = entry(5, session:parameter)
        cAblApp   = entry(6, session:parameter)
        cType     = entry(7, session:parameter)
        .
else
    assign
        cScheme   = dynamic-function("getParameter" in source-procedure, "Scheme") when (dynamic-function("getParameter" in source-procedure, "Scheme") gt "") eq true
        cHost     = dynamic-function("getParameter" in source-procedure, "Host") when (dynamic-function("getParameter" in source-procedure, "Host") gt "") eq true
        cPort     = dynamic-function("getParameter" in source-procedure, "Port") when (dynamic-function("getParameter" in source-procedure, "Port") gt "") eq true
        cUserId   = dynamic-function("getParameter" in source-procedure, "UserID") when (dynamic-function("getParameter" in source-procedure, "UserID") gt "") eq true
        cPassword = dynamic-function("getParameter" in source-procedure, "PassWD") when (dynamic-function("getParameter" in source-procedure, "PassWD") gt "") eq true
        cAblApp   = dynamic-function("getParameter" in source-procedure, "ABLApp") when (dynamic-function("getParameter" in source-procedure, "ABLApp") gt "") eq true
        cType     = dynamic-function("getParameter" in source-procedure, "Type") when (dynamic-function("getParameter" in source-procedure, "Type") gt "") eq true
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

    if JsonPropertyHelper:HasTypedProperty(oAgent, "pid", JsonDataType:string) then
        assign cPID = oAgent:GetCharacter("pid").

    /* Perform a delete on the type of item to reset. */
    do stop-after 10
    on error undo, throw
    on stop undo, retry:
        if retry then
            undo, throw new Progress.Lang.AppError("Encountered a stop condition", 0).

        if (cPID gt "") ne true then
            undo, throw new Progress.Lang.AppError(substitute("Invalid Agent PID '&1'", cPID), 0).

        case cType:
            when "stats" then
                message oMgrConn:GetOpOutcome(oMgrConn:ResetAgentStats(cAblApp, integer(cPID))).
            when "logs" then
                message oMgrConn:GetOpOutcome(oMgrConn:ResetDeferredLog(cAblApp, integer(cPID))).
            otherwise
                undo, throw new Progress.Lang.AppError(substitute("Unknown reset type '&1'", cType), 0).
        end case.

        catch err as Progress.Lang.Error:
            message substitute("Error Resetting &1 PID &2: &3", cType, cPID, err:GetMessage(1)).
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
