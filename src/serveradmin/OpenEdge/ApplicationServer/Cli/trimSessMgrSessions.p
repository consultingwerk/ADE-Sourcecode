/**************************************************************************
Copyright (c) 2023-2024 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/**
 * Author(s): Dustin Grau (dugrau@progress.com)
 *
 * Trim all Session Manager and Tomcat HTTP sessions for an ABL/Web App.
 * Usage: trimSessMgrSessions.p <params>
 *  Parameter Default/Allowed
 *   Scheme       [http|https]
 *   Hostname     [localhost]
 *   PAS Port     [8810]
 *   UserId       [tomcat]
 *   Password     [tomcat]
 *   ABL App      [oepas1]
 *   Web App      [ROOT]
 *   TerminateOpt [0|1]
 */

using OpenEdge.ApplicationServer.Util.OEManagerConnection.
using OpenEdge.ApplicationServer.Util.OEManagerEndpoint.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.JsonDataTypeEnum.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.

define variable cHttpUrl   as character       no-undo.
define variable oJsonResp  as JsonObject      no-undo.
define variable oAgents    as JsonArray       no-undo.
define variable oAgentMap  as StringStringMap no-undo.
define variable oSessions  as JsonArray       no-undo.
define variable oSession   as JsonObject      no-undo.
define variable oStacks    as JsonArray       no-undo.
define variable iLoop      as integer         no-undo.
define variable iSessions  as integer         no-undo.
define variable cAgentID   as character       no-undo.
define variable cOutFile   as character       no-undo.
define variable cPID       as character       no-undo.
define variable cSessID    as character       no-undo.
define variable cSession   as character       no-undo.
define variable cTerminate as character       no-undo initial "0".
define variable cTermType  as character       no-undo.
define variable cWebApp    as character       no-undo initial "".
define variable cWebAppUrl as character       no-undo.

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
        cScheme    = entry(1, session:parameter)
        cHost      = entry(2, session:parameter)
        cPort      = entry(3, session:parameter)
        cUserId    = entry(4, session:parameter)
        cPassword  = entry(5, session:parameter)
        cAblApp    = entry(6, session:parameter)
        cWebApp    = entry(7, session:parameter)
        cTerminate = entry(8, session:parameter)
        cSessID    = entry(9, session:parameter)
        .
else
    assign
        cScheme    = dynamic-function("getParameter" in source-procedure, "Scheme") when (dynamic-function("getParameter" in source-procedure, "Scheme") gt "") eq true
        cHost      = dynamic-function("getParameter" in source-procedure, "Host") when (dynamic-function("getParameter" in source-procedure, "Host") gt "") eq true
        cPort      = dynamic-function("getParameter" in source-procedure, "Port") when (dynamic-function("getParameter" in source-procedure, "Port") gt "") eq true
        cUserId    = dynamic-function("getParameter" in source-procedure, "UserID") when (dynamic-function("getParameter" in source-procedure, "UserID") gt "") eq true
        cPassword  = dynamic-function("getParameter" in source-procedure, "PassWD") when (dynamic-function("getParameter" in source-procedure, "PassWD") gt "") eq true
        cAblApp    = dynamic-function("getParameter" in source-procedure, "ABLApp") when (dynamic-function("getParameter" in source-procedure, "ABLApp") gt "") eq true
        cWebApp    = dynamic-function("getParameter" in source-procedure, "WebApp") when (dynamic-function("getParameter" in source-procedure, "WebApp") gt "") eq true
        cTerminate = dynamic-function("getParameter" in source-procedure, "TerminateOpt") when (dynamic-function("getParameter" in source-procedure, "TerminateOpt") gt "") eq true
        cSessID    = dynamic-function("getParameter" in source-procedure, "SessionID") when (dynamic-function("getParameter" in source-procedure, "SessionID") gt "") eq true
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

/* We should not proceed unless all required parameters are provided. */
if (cWebApp gt "") ne true then
    undo, throw new Progress.Lang.AppError("WebApp name was not provided", 0).

/* Create and OEManager connection for API calls. */
assign oMgrConn = OEManagerConnection:Build(cScheme, cHost, integer(cPort), cUserId, cPassword).

/* Output the name of the program being executed. */
oMgrConn:LogCommand("RUN", this-procedure:name).

/* Create an easy lookup of alphanumeric AgentID's to a matching PID. */
assign oAgentMap = new StringStringMap().
assign oAgents = oMgrConn:GetAgents(cAblApp).

if oAgents:Length gt 0 then
do iLoop = 1 to oAgents:Length:
    oAgentMap:Put(oAgents:GetJsonObject(iLoop):GetCharacter("agentId"), oAgents:GetJsonObject(iLoop):GetCharacter("pid")).
end.

/* Get client HTTP sessions from the Session Manager. */
message substitute("Looking for SessionManager Sessions of &1...", cAblApp).
message substitute("[Using &1 Termination]", cTermType).
assign oSessions = oMgrConn:GetClientSessions(cAblApp).
assign iSessions = oSessions:Length.
message substitute("~nSession Manager Sessions: &1", iSessions).

if iSessions gt 0 then
SESSIONBLK:
do iLoop = 1 to iSessions
on error undo, next SESSIONBLK
on stop undo, next SESSIONBLK:
    oSession = oSessions:GetJsonObject(iLoop).

    if JsonPropertyHelper:HasTypedProperty(oSession, "sessionID", JsonDataType:string) then
        assign
            cSession = oSession:GetCharacter("sessionID")
            cAgentID = oSession:GetCharacter("agentID")
            .

    /* If given a distinct Session ID to terminate, skip to the next session if this does not match. */
    if (cSessID gt "") eq true and cSession ne cSessID then next SESSIONBLK.

    if (cSession gt "") eq true then do
    on error undo, next:
        message substitute("Found SessionManager Session: &1 [Elapsed &2 sec.]", cSession,
                           trim(string(oSession:GetInt64("elapsedTimeMs") / 1000, ">>>,>>>,>>9"))).

        do stop-after 10
        on error undo, throw
        on stop undo, retry:
            if retry then
                undo, throw new Progress.Lang.AppError("Encountered a stop condition", 0).

            /* First write the current stack information for the session to be terminated. */
            assign cPID = string(oAgentMap:Get(cAgentID)).
            assign oStacks = oMgrConn:GetAgentSessionStacks(cAblApp, integer(cPID), cSession).
            if oStacks:Length gt 0 then do:
                message substitute("Saving stack information for MSAgent PID &1, Session &2...", integer(cPID), cSession).
                assign cOutFile = substitute("agentSessionStacks_&1_&2_&3.json", integer(cPID), cSession, replace(iso-date(now), ":", "_")).
                oStacks:WriteFile(session:temp-directory + cOutFile, true). /* Write entire response to disk. */
                message substitute("~tStack data written to &1", cOutFile).
            end.

            /* Terminate the client session using the specified option. */
            assign oJsonResp = oMgrConn:TerminateClientSession(cAblApp, integer(cTerminate), cSession).

            if JsonPropertyHelper:HasTypedProperty(oJsonResp, "operation", JsonDataType:String) and
               JsonPropertyHelper:HasTypedProperty(oJsonResp, "outcome", JsonDataType:String) then
                message substitute("~t&1 (&2): &3 [&4]",
                                   oJsonResp:GetCharacter("operation"),
                                   cTermType,
                                   oJsonResp:GetCharacter("outcome"),
                                   cSession).

            catch err as Progress.Lang.Error:
                message substitute("Error Closing Session &1: &2", cSession, err:GetMessage(1)).
                next SESSIONBLK.
            end catch.
        end. /* do stop-after */
    end. /* Has sessionID */
end. /* iLoop - sessions */

/* Continue with expriring Tomcat sessions only if not terminating a specific session. */
if (cSessID gt "") ne true then do:
    /* Expire any/all sessions via the Tomcat Web Application Manager for this ABLApp/WebApp pair. */
    assign cHttpUrl = OEManagerEndpoint:TomcatSessions + "?idle=0&path".
    if cWebApp eq "ROOT" then
        assign cWebAppUrl = "/".
    else
        assign cWebAppUrl = substitute("/&1", cWebApp).

    assign cHttpUrl = substitute("&1=&2", cHttpUrl, cWebAppUrl). /* Specify the WebApp as a URL */
    message substitute("~nExpiring sessions via Tomcat for &1 ...", cWebAppUrl).
    assign oJsonResp = oMgrConn:GetData(cHttpUrl).

    if valid-object(oJsonResp) and oJsonResp:Has("result") then
    do stop-after 30
    on error undo, leave
    on stop undo, leave:
        define variable cTemp as character no-undo.
        {&_proparse_ prolint-nowarn(overflow)}
        assign cTemp = string(oJsonResp:GetJsonText("result")).
        assign cTemp = replace(cTemp, "~\r~\n", "~n").
        assign cTemp = replace(cTemp, "~\n", "~n").
        assign cTemp = replace(cTemp, "~\~/", "~/").
        message substitute("Tomcat Manager Response:~n&1", cTemp).
    end. /* oJsonResp - Tomcat */
end. /* sessions */

catch err as Progress.Lang.Error:
    put unformatted substitute("~nError while communicating with PASOE instance: &1", err:GetMessage(1)) skip.
end catch.
finally:
    /* Return value expected by PCT Ant task. */
    {&_proparse_ prolint-nowarn(returnfinally)}
    return string(0).
end finally.
