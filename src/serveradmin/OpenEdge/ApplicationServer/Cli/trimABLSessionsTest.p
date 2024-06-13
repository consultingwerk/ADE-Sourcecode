/**************************************************************************
Copyright (c) 2023-2024 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/**
 * Author(s): Dustin Grau (dugrau@progress.com)
 *
 * Trim random (or alternating) ABL sessions for all MSAgents of an ABLApp.
 * Usage: trimABLSessionsTest.p <params>
 *  Parameter Default/Allowed
 *   Scheme       [http|https]
 *   Hostname     [localhost]
 *   PAS Port     [8810]
 *   UserId       [tomcat]
 *   Password     [tomcat]
 *   ABL App      [oepas1]
 *   TerminateOpt [0|1|2]
 *   Pattern      [#|RAND]
 */

using OpenEdge.ApplicationServer.Util.OEManagerConnection.
using OpenEdge.ApplicationServer.Util.OEManagerEndpoint.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.JsonDataTypeEnum.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.

define variable oAgents    as JsonArray  no-undo.
define variable oAgent     as JsonObject no-undo.
define variable oSessions  as JsonArray  no-undo.
define variable oStacks    as JsonArray  no-undo.
define variable oTemp      as JsonObject no-undo.
define variable iLoop      as integer    no-undo.
define variable iLoop2     as integer    no-undo.
define variable iTotSess   as integer    no-undo.
define variable cOutFile   as character  no-undo.
define variable cPID       as character  no-undo.
define variable iSession   as integer    no-undo.
define variable iSelect    as integer    no-undo.
define variable cPattern   as character  no-undo.
define variable cTerminate as character  no-undo initial "0".
define variable cTermType  as character  no-undo.

/* Manage the server connection to the OEManager webapp */
define variable oMgrConn  as OEManagerConnection no-undo.
define variable cScheme   as character           no-undo initial "http".
define variable cHost     as character           no-undo initial "localhost".
define variable cPort     as character           no-undo.
define variable cUserId   as character           no-undo.
define variable cPassword as character           no-undo.
define variable cAblApp   as character           no-undo.

/* Check for passed-in arguments/parameters. */
if num-entries(session:parameter) ge 8 then
    assign
        cScheme    = entry(1, session:parameter)
        cHost      = entry(2, session:parameter)
        cPort      = entry(3, session:parameter)
        cUserId    = entry(4, session:parameter)
        cPassword  = entry(5, session:parameter)
        cAblApp    = entry(6, session:parameter)
        cTerminate = entry(7, session:parameter)
        cPattern   = entry(8, session:parameter)
        .
else
    assign
        cScheme    = dynamic-function("getParameter" in source-procedure, "Scheme") when (dynamic-function("getParameter" in source-procedure, "Scheme") gt "") eq true
        cHost      = dynamic-function("getParameter" in source-procedure, "Host") when (dynamic-function("getParameter" in source-procedure, "Host") gt "") eq true
        cPort      = dynamic-function("getParameter" in source-procedure, "Port") when (dynamic-function("getParameter" in source-procedure, "Port") gt "") eq true
        cUserId    = dynamic-function("getParameter" in source-procedure, "UserID") when (dynamic-function("getParameter" in source-procedure, "UserID") gt "") eq true
        cPassword  = dynamic-function("getParameter" in source-procedure, "PassWD") when (dynamic-function("getParameter" in source-procedure, "PassWD") gt "") eq true
        cAblApp    = dynamic-function("getParameter" in source-procedure, "ABLApp") when (dynamic-function("getParameter" in source-procedure, "ABLApp") gt "") eq true
        cTerminate = dynamic-function("getParameter" in source-procedure, "TerminateOpt") when (dynamic-function("getParameter" in source-procedure, "TerminateOpt") gt "") eq true
        cPattern   = dynamic-function("getParameter" in source-procedure, "Pattern") when (dynamic-function("getParameter" in source-procedure, "Pattern") gt "") eq true
        .

case cTerminate:
    when "0" then assign cTermType = "Graceful".
    when "1" then assign cTermType = "Forced".
    when "2" then assign cTermType = "Finish".
    otherwise
        assign /* Must assume graceful option. */
            cTerminate = "0"
            cTermType  = "Graceful"
            .
end case.

/* Create and OEManager connection for API calls. */
assign oMgrConn = OEManagerConnection:Build(cScheme, cHost, integer(cPort), cUserId, cPassword).

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

    /* Get sessions and determine non-idle states on active MSAgents. */
    if oAgent:GetCharacter("state") eq "available" then do:
        assign oSessions = oMgrConn:GetAgentSessions(cAblApp, integer(cPID)).
        assign iTotSess = oSessions:Length.

        message substitute("Found MSAgent PID &1 with &2 sessions", cPID, iTotSess).

        /* If a random number is selected, pick a session number between 1 and the total for this agent. */
        if cPattern begins "rand" then do:
            if iTotSess gt 2 then
                assign iSelect = random(2, iTotSess).
            else
                assign iSelect = 2. /* Force every 2 sessions. */
        end.
        else
            assign iSelect = integer(cPattern) no-error.

        if error-status:error then
            undo, throw new Progress.Lang.AppError("Invalid pattern value, must be a number or 'random'", 0).

        if iSelect eq 1 then
            undo, throw new Progress.Lang.AppError("Pattern of 1 will terminate all, please use 'trimall'", 0).

        message substitute("Termination Pattern: Every &1 Sessions", iSelect).

        if iTotSess gt 0 then
        SESSIONBLK:
        do iLoop2 = 1 to iTotSess
        on error undo, next SESSIONBLK
        on stop undo, next SESSIONBLK:
            if oSessions:GetType(iLoop2) eq JsonDataType:Object then
                assign oTemp = oSessions:GetJsonObject(iLoop2).
            else
                next SESSIONBLK.

            if JsonPropertyHelper:HasTypedProperty(oTemp, "SessionId", JsonDataType:number) then
                assign iSession = oTemp:GetInteger("SessionId").

            if (iLoop2 modulo iSelect) eq 0 then
                message substitute("Terminating &1 ABL session: &2 [using &3 termination]", oTemp:GetCharacter("SessionState"), iSession, cTermType).
            else
                next SESSIONBLK.

            do stop-after 10
            on error undo, throw
            on stop undo, retry:
                if retry then
                    undo, throw new Progress.Lang.AppError("Encountered a stop condition", 0).

                /* First write the current stack information for the session to be terminated. */
                assign oStacks = oMgrConn:GetAgentSessionStacks(cAblApp, integer(cPID), iSession).
                if oStacks:Length gt 0 then do:
                    message substitute("Saving stack information for MSAgent PID &1, Session &2...", cPID, iSession).
                    assign cOutFile = substitute("agentSessionStacks_&1_&2_&3.json", cPID, iSession, replace(iso-date(now), ":", "_")).
                    oStacks:WriteFile(session:temp-directory + cOutFile, true). /* Write entire response to disk. */
                    message substitute("~tStack data written to &1", cOutFile).
                end.

                /* Terminate the agent-session using the specified option. */
                message oMgrConn:GetOpOutcome(oMgrConn:TerminateAblSession(cAblApp, integer(cPID), iSession, integer(cTerminate))).

                catch err as Progress.Lang.Error:
                    message substitute("Error Terminating ABL Session &1: &2", iSession, err:GetMessage(1)).
                    next SESSIONBLK.
                end catch.
            end. /* do stop-after */
        end. /* iLoop2 - session */
    end. /* agent state = available */
    else
        message substitute("MSAgent PID &1 not AVAILABLE, skipping trim.", cPID).
end. /* iLoop - agent */

catch err as Progress.Lang.Error:
    put unformatted substitute("~nError while communicating with PASOE instance: &1", err:GetMessage(1)) skip.
end catch.
finally:
    /* Return value expected by PCT Ant task. */
    {&_proparse_ prolint-nowarn(returnfinally)}
    return string(0).
end finally.
