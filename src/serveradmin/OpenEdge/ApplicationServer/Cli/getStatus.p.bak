/**************************************************************************
Copyright (c) 2023-2024 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/**
 * Author(s): Dustin Grau (dugrau@progress.com)
 *
 * Obtains status about all running MSAgents from PASOE instance and ABLApp.
 * Usage: getStatus.p <params>
 *  Parameter Default/Allowed
 *   Scheme   [http|https]
 *   Hostname [localhost]
 *   PAS Port [8810]
 *   UserId   [tomcat]
 *   Password [tomcat]
 *   ABL App  [oepas1]
 *
 * Reference: https://knowledgebase.progress.com/articles/Article/P89737
 */

using OpenEdge.ApplicationServer.Util.OEManagerConnection.
using OpenEdge.ApplicationServer.Util.OEManagerEndpoint.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.JsonDataTypeEnum.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Core.SemanticVersion.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.

define variable cOutFile   as character       no-undo.
define variable cOutDate   as character       no-undo.
define variable oClSess    as JsonArray       no-undo.
define variable oMetrics   as JsonObject      no-undo.
define variable oAgentMap  as StringStringMap no-undo.
define variable iLoop      as integer         no-undo.
define variable iLoop2     as integer         no-undo.
define variable iLoop3     as integer         no-undo.
define variable iCollect   as integer         no-undo.
define variable iBaseMem   as int64           no-undo.
define variable iTotClSess as integer         no-undo.
define variable dInstTime  as datetime        no-undo.
define variable cBound     as character       no-undo.
define variable oVersion   as SemanticVersion no-undo.
define variable lHasApps   as logical         no-undo.
define variable lIsMin122  as logical         no-undo.
define variable lIsMin127  as logical         no-undo.
define variable lIsMin128  as logical         no-undo.

/* Manage the server connection to the OEManager webapp */
define variable oMgrConn  as OEManagerConnection no-undo.
define variable cScheme   as character           no-undo initial "http".
define variable cHost     as character           no-undo initial "localhost".
define variable cPort     as character           no-undo.
define variable cUserId   as character           no-undo.
define variable cPassword as character           no-undo.
define variable cAblApp   as character           no-undo.

define temp-table ttAgent no-undo
    field agentID     as character
    field agentPID    as integer
    field agentState  as character
    field startTime   as datetime-tz
    field runningTime as int64
    field maxSessions as int64
    field ablSessions as int64
    field availSess   as int64
    field openConns   as int64
    field memoryBytes as int64
    .

define temp-table ttAgentSession no-undo
    field agentID        as character
    field agentPID       as integer
    field sessionID      as integer
    field sessionState   as character
    field startTime      as datetime-tz
    field runningTime    as int64
    field memoryBytes    as int64
    field memAtRestBytes as int64
    field memActiveBytes as int64
    field reqCompleted   as int64
    field reqFailed      as int64
    field boundSession   as character
    field boundReqID     as character
    .

define dataset dsAgentSession for ttAgent, ttAgentSession
    data-relation AgentID for ttAgent, ttAgentSession relation-fields(agentID,agentID) nested.

function FormatDecimal returns character ( input pcValue as character ) forward.
function FormatLongNumber returns character ( input pcValue as character, input plTrim as logical ) forward.
function FormatMemory returns character ( input piValue as int64, input plTrim as logical ) forward.
function FormatMsTime returns character ( input piValue as int64 ) forward.
function FormatCharAsNumber returns character ( input pcValue as character ) forward.
function FormatIntAsNumber returns character ( input piValue as integer ) forward.

/* Check for passed-in arguments/parameters. */
if num-entries(session:parameter) ge 6 then
    assign
        cScheme   = entry(1, session:parameter)
        cHost     = entry(2, session:parameter)
        cPort     = entry(3, session:parameter)
        cUserId   = entry(4, session:parameter)
        cPassword = entry(5, session:parameter)
        cAblApp   = entry(6, session:parameter)
        .
else
    assign
        cScheme   = dynamic-function("getParameter" in source-procedure, "Scheme") when (dynamic-function("getParameter" in source-procedure, "Scheme") gt "") eq true
        cHost     = dynamic-function("getParameter" in source-procedure, "Host") when (dynamic-function("getParameter" in source-procedure, "Host") gt "") eq true
        cPort     = dynamic-function("getParameter" in source-procedure, "Port") when (dynamic-function("getParameter" in source-procedure, "Port") gt "") eq true
        cUserId   = dynamic-function("getParameter" in source-procedure, "UserID") when (dynamic-function("getParameter" in source-procedure, "UserID") gt "") eq true
        cPassword = dynamic-function("getParameter" in source-procedure, "PassWD") when (dynamic-function("getParameter" in source-procedure, "PassWD") gt "") eq true
        cAblApp   = dynamic-function("getParameter" in source-procedure, "ABLApp") when (dynamic-function("getParameter" in source-procedure, "ABLApp") gt "") eq true
        iBaseMem  = int64(dynamic-function("getParameter" in source-procedure, "BaseMem")) when (dynamic-function("getParameter" in source-procedure, "BaseMem") gt "") eq true
        .

/* Create and OEManager connection for API calls. */
assign oMgrConn = OEManagerConnection:Build(cScheme, cHost, integer(cPort), cUserId, cPassword).
assign cOutDate = replace(iso-date(now), ":", "_").
assign oAgentMap = new StringStringMap().

/* Output the name of the program being executed. */
oMgrConn:LogCommand("RUN", this-procedure:name).

/* Begin output of status information to a dated file. */
assign cOutFile = substitute(session:temp-directory + "status_&1_&2.txt", cAblApp, cOutDate).
message substitute("Starting output to file: &1 ...", cOutFile).
output to value(cOutFile).

/* Start with some basic header information for this report. */
put unformatted substitute("Utility Runtime: &1", proversion(1)) skip.     /* Reports the OE runtime version used by this utility.             */
put unformatted substitute("Report Executed: &1", iso-date(now)) skip.     /* Produce a timestamp relative to where utility was run.           */
put unformatted substitute(" PASOE Instance: &1", oMgrConn:Instance) skip. /* Reports the combined scheme, hostname, and port of the instance. */

/* Gather all necessary metrics. */
run GetApplications.
if lHasApps then do:
    /* Cannot continue if no applications exist. */
    run GetProperties.
    run GetAgents.
    run GetSessions.
end.

finally:
    output close.

    message "~n". /* Denotes we completed the output, should just be an empty line on screen. */

    define variable lcText as longchar no-undo.
    define variable iLine  as integer  no-undo.
    define variable iLines as integer  no-undo.
    copy-lob from file cOutFile to lcText no-convert no-error.
    assign iLines = num-entries(lcText, "~n").
    if iLines ge 1 then
    do iLine = 1 to iLines:
        message string(entry(iLine, lcText, "~n")).
    end.

    /* Return value expected by PCT Ant task. */
    {&_proparse_ prolint-nowarn(returnfinally)}
    return string(0).
end finally.

/* PROCEDURES / FUNCTIONS */

function FormatDecimal returns character ( input pcValue as character ):
    return trim(string(int64(pcValue) / 60000, "->>9.9")).
end function. /* FormatDecimal */

function FormatMemory returns character ( input piValue as int64, input plTrim as logical ):
    /* Should show up to 999,999,999 GB which is more than expected for any process. */
    return FormatLongNumber(string(round(piValue / 1024, 0)), plTrim).
end function. /* FormatMemory */

function FormatMsTime returns character ( input piValue as int64):
    define variable iMS  as integer no-undo.
    define variable iSec as integer no-undo.
    define variable iMin as integer no-undo.
    define variable iHr  as integer no-undo.
    define variable iDay as integer no-undo.

    /* Break down millisecond time into D:H:M:S.SSS */
    assign iMS = piValue modulo 1000.
    assign piValue = (piValue - iMS) / 1000.
    assign iSec = piValue modulo 60.
    assign piValue = (piValue - iSec) / 60.
    assign iMin = piValue modulo 60.
    {&_proparse_ prolint-nowarn(overflow)}
    assign iHr = (piValue - iMin) / 60.
    {&_proparse_ prolint-nowarn(overflow)}
    assign iDay = truncate(iHr / 24, 0).
    if iDay gt 0 then
        assign iHr = iHr modulo 24.

    /* Allow for days beyond 365 as we do not calculate for years (though possible, this is a highly unlikely scenario). */
    return trim(string(iDay, ">>>,>99")) + ":" + string(iHr, "99") + ":" + string(iMin, "99") + ":" + string(iSec, "99") + "." + string(iMS, "999").
end function. /* FormatMsTime */

function FormatLongNumber returns character ( input pcValue as character, input plTrim as logical ):
    if plTrim then
        return trim(string(int64(pcValue), "->>>,>>>,>>9")).
    else
        return string(int64(pcValue), "->>>,>>>,>>9").
end function. /* FormatCharAsNumber */

function FormatCharAsNumber returns character ( input pcValue as character ):
    return string(integer(pcValue), ">>9").
end function. /* FormatCharAsNumber */

function FormatIntAsNumber returns character ( input piValue as integer ):
    return string(piValue, ">,>>9").
end function. /* FormatIntAsNumber */

/* Get available applications and confirm the given name as valid (and for proper case). */
procedure GetApplications:
    define variable oABLApps  as JsonArray  no-undo.
    define variable oTemp     as JsonObject no-undo.
    define variable oWebApps  as JsonArray  no-undo.
    define variable oWebTrans as JsonArray  no-undo.
    define variable cVersion  as character  no-undo.

    /* Set a default object in case we have no applications or cannot determine the version. */
    assign oVersion = new SemanticVersion(0, 0 ,0).

    assign oABLApps = oMgrConn:GetApplications().
    if oABLApps:Length gt 0 then
    do iLoop = 1 to oABLApps:Length:
        assign lHasApps = true. /* Important: Set this to indicate the server is alive and returned with ABL Apps. */

        assign oTemp = oABLApps:GetJsonObject(iLoop).
        if oTemp:Has("name") and oTemp:GetCharacter("name") eq cAblApp then do:
            /* This should be the proper and case-sensitive name of the ABLApp, so let's make sure we use that going forward. */
            assign cAblApp = oTemp:GetCharacter("name").

            /* Remember the OpenEdge version for this PAS instance, sent in the format "v#.#.# ( YYYY-MM-DD )". */
            if JsonPropertyHelper:HasTypedProperty(oTemp, "version", JsonDataType:String) then do:
                cVersion = oTemp:GetCharacter("version").
                assign oVersion = SemanticVersion:Parse(entry(1, replace(cVersion, "v", ""), " ")).
            end.

            /* Reports the full ABL Application name and OpenEdge version as reported by the monitored PAS instance itself. */
            put unformatted substitute("~nABL Application Information [&1 - &2]", cAblApp, cVersion) skip.

            if JsonPropertyHelper:HasTypedProperty(oTemp, "webapps", JsonDataType:Array) then do:
                assign oWebApps = oTemp:GetJsonArray("webapps").
                do iLoop2 = 1 to oWebApps:Length:
                    if oWebApps:GetJsonObject(iLoop2):Has("name") then
                        put unformatted substitute("~tWebApp: &1",  oWebApps:GetJsonObject(iLoop2):GetCharacter("name")) skip.

                    assign oWebTrans = oWebApps:GetJsonObject(iLoop2):GetJsonArray("transports").
                    do iLoop3 = 1 to oWebTrans:Length:
                        put unformatted substitute("~t&1&2: &3",
                                                   fill(" ", 6 - length(oWebTrans:GetJsonObject(iLoop3):GetCharacter("name"), "raw")),
                                                   oWebTrans:GetJsonObject(iLoop3):GetCharacter("name"),
                                                   oWebTrans:GetJsonObject(iLoop3):GetCharacter("state")) skip.
                    end. /* transport */
                end. /* webapp */
            end. /* has webapps */
        end. /* matching ABLApp */
    end. /* Application */
    else
        put unformatted "~nNo applications available. Is the PASOE instance correctly configured and running?" skip.

    /* Set some simple indicators for minimum OE versions which affects other API calls. */
    assign lIsMin122 = (oVersion:Major eq 12 and oVersion:Minor ge 2) or oVersion:Major gt 12.
    assign lIsMin127 = (oVersion:Major eq 12 and oVersion:Minor ge 7) or oVersion:Major gt 12.
    assign lIsMin128 = (oVersion:Major eq 12 and oVersion:Minor ge 8) or oVersion:Major gt 12.

    catch err as Progress.Lang.Error:
        put unformatted substitute("~nUnable to get application list from PASOE instance: &1", err:GetMessage(1)) skip.
    end catch.
end procedure.

/* Get the configured max for ABLSessions/Connections per MSAgent, along with min/max/initial MSAgents. */
procedure GetProperties:
    define variable oSessMgrProps as JsonObject no-undo.
    define variable oAgntMgrProps as JsonObject no-undo.

    assign oSessMgrProps = oMgrConn:GetSessionManagerProperties(cAblApp).

    put unformatted "~nManager Properties" skip.

    if JsonPropertyHelper:HasTypedProperty(oSessMgrProps, "maxAgents", JsonDataType:string) then
        put unformatted substitute("~t        Maximum Agents:~t~t&1", FormatCharAsNumber(oSessMgrProps:GetCharacter("maxAgents"))) skip.

    if JsonPropertyHelper:HasTypedProperty(oSessMgrProps, "minAgents", JsonDataType:string) then
        put unformatted substitute("~t        Minimum Agents:~t~t&1", FormatCharAsNumber(oSessMgrProps:GetCharacter("minAgents"))) skip.

    if JsonPropertyHelper:HasTypedProperty(oSessMgrProps, "numInitialAgents", JsonDataType:string) then
        put unformatted substitute("~t        Initial Agents:~t~t&1", FormatCharAsNumber(oSessMgrProps:GetCharacter("numInitialAgents"))) skip.

    if JsonPropertyHelper:HasTypedProperty(oSessMgrProps, "maxConnectionsPerAgent", JsonDataType:string) then
        put unformatted substitute("~tMax. Connections/Agent:~t~t&1", FormatCharAsNumber(oSessMgrProps:GetCharacter("maxConnectionsPerAgent"))) skip.

    if JsonPropertyHelper:HasTypedProperty(oSessMgrProps, "maxABLSessionsPerAgent", JsonDataType:string) then
        put unformatted substitute("~tMax. ABLSessions/Agent:~t~t&1", FormatCharAsNumber(oSessMgrProps:GetCharacter("maxABLSessionsPerAgent"))) skip.

    if JsonPropertyHelper:HasTypedProperty(oSessMgrProps, "idleConnectionTimeout", JsonDataType:string) then
        put unformatted substitute("~t    Idle Conn. Timeout: &1 ms (&2)",
                                   FormatLongNumber(oSessMgrProps:GetCharacter("idleConnectionTimeout"), false),
                                   FormatMsTime(integer(oSessMgrProps:GetCharacter("idleConnectionTimeout")))) skip.

    if JsonPropertyHelper:HasTypedProperty(oSessMgrProps, "idleSessionTimeout", JsonDataType:string) then
        put unformatted substitute("~t  Idle Session Timeout: &1 ms (&2)",
                                   FormatLongNumber(oSessMgrProps:GetCharacter("idleSessionTimeout"), false),
                                   FormatMsTime(integer(oSessMgrProps:GetCharacter("idleSessionTimeout")))) skip.

    if JsonPropertyHelper:HasTypedProperty(oSessMgrProps, "idleAgentTimeout", JsonDataType:string) then
        put unformatted substitute("~t    Idle Agent Timeout: &1 ms (&2)",
                                   FormatLongNumber(oSessMgrProps:GetCharacter("idleAgentTimeout"), false),
                                   FormatMsTime(integer(oSessMgrProps:GetCharacter("idleAgentTimeout")))) skip.

    if JsonPropertyHelper:HasTypedProperty(oSessMgrProps, "idleResourceTimeout", JsonDataType:string) then
        put unformatted substitute("~t Idle Resource Timeout: &1 ms (&2)",
                                   FormatLongNumber(oSessMgrProps:GetCharacter("idleResourceTimeout"), false),
                                   FormatMsTime(integer(oSessMgrProps:GetCharacter("idleResourceTimeout")))) skip.

    if JsonPropertyHelper:HasTypedProperty(oSessMgrProps, "connectionWaitTimeout", JsonDataType:string) then
        put unformatted substitute("~t    Conn. Wait Timeout: &1 ms (&2)",
                                   FormatLongNumber(oSessMgrProps:GetCharacter("connectionWaitTimeout"), false),
                                   FormatMsTime(integer(oSessMgrProps:GetCharacter("connectionWaitTimeout")))) skip.

    if JsonPropertyHelper:HasTypedProperty(oSessMgrProps, "requestWaitTimeout", JsonDataType:string) then
        put unformatted substitute("~t  Request Wait Timeout: &1 ms (&2)",
                                   FormatLongNumber(oSessMgrProps:GetCharacter("requestWaitTimeout"), false),
                                   FormatMsTime(integer(oSessMgrProps:GetCharacter("requestWaitTimeout")))) skip.

    if JsonPropertyHelper:HasTypedProperty(oSessMgrProps, "collectMetrics", JsonDataType:string) then
        assign iCollect = integer(oSessMgrProps:GetCharacter("collectMetrics")). /* Remember for later. */

    /* Get the configured initial number of sessions along with the min available sessions. */
    assign oAgntMgrProps = oMgrConn:GetAgentManagerProperties(cAblApp).

    if JsonPropertyHelper:HasTypedProperty(oAgntMgrProps, "numInitialSessions", JsonDataType:string) then
        put unformatted substitute("~tInitial Sessions/Agent:~t~t&1", FormatCharAsNumber(oAgntMgrProps:GetCharacter("numInitialSessions"))) skip.

    if JsonPropertyHelper:HasTypedProperty(oAgntMgrProps, "minAvailableABLSessions", JsonDataType:string) then
        put unformatted substitute("~tMin. Avail. Sess/Agent:~t~t&1", FormatCharAsNumber(oAgntMgrProps:GetCharacter("minAvailableABLSessions"))) skip.

    finally:
        if valid-object(oSessMgrProps) then
            delete object oSessMgrProps.

        if valid-object(oAgntMgrProps) then
            delete object oAgntMgrProps.
    end finally.
end procedure.

/* Initial URL to obtain a list of all agents for an ABL Application. */
procedure GetAgents:
    define variable iTotAgent as integer     no-undo.
    define variable iTotSess  as integer     no-undo.
    define variable iTotThrd  as integer     no-undo.
    define variable iBusySess as integer     no-undo.
    define variable iUsedSess as integer     no-undo.
    define variable dStart    as datetime    no-undo.
    define variable dTemp     as datetime-tz no-undo.
    define variable oAgents   as JsonArray   no-undo.
    define variable oAgent    as JsonObject  no-undo.
    define variable oSessions as JsonArray   no-undo.
    define variable oSessInfo as JsonObject  no-undo.
    define variable oStatHist as JsonArray   no-undo.
    define variable oTemp     as JsonObject  no-undo.
    define variable oThreads  as JsonArray   no-undo.
    define variable iMinMem   as int64       no-undo.
    define variable iTotalMem as int64       no-undo.

    empty temp-table ttAgent.
    empty temp-table ttAgentSession.

    /* Get metrics about the session manager which comes from the collectMetrics flag. */
    assign oMetrics = oMgrConn:GetSessionMetrics(cAblApp).
    if JsonPropertyHelper:HasTypedProperty(oMetrics, "accessTime", JsonDataType:String) then do:
        /* Get the server access time (should be a timestamp from the server's timezone). */
        assign dTemp = oMetrics:GetDateTimeTZ("accessTime").
        assign dInstTime = datetime(date(dTemp), mtime(dTemp)).
    end.
    else
        assign dInstTime = now.

    /* Capture all available agent info to a temp-table before we proceed. */
    assign oAgents = oMgrConn:GetAgents(cAblApp).
    assign iTotAgent = oAgents:Length.
    if oAgents:Length eq 0 then
        put unformatted "~nNo MSAgents running" skip.
    else
    AGENTBLK:
    do iLoop = 1 to iTotAgent
    on error undo, next AGENTBLK:
        oAgent = oAgents:GetJsonObject(iLoop).

        create ttAgent.
        assign
            ttAgent.agentID    = oAgent:GetCharacter("agentId")
            ttAgent.agentPID   = integer(oAgent:GetCharacter("pid"))
            ttAgent.agentState = oAgent:GetCharacter("state")
            .

        /* Provides a simple means of lookup later to relate agentID to PID. */
        oAgentMap:Put(ttAgent.agentID, string(ttAgent.agentPID)).

        release ttAgent no-error.
    end. /* iLoop - Agents */

    /* This data will be related to the MSAgent-sessions to denote which ones are bound. */
    assign oClSess = oMgrConn:GetClientSessions(cAblApp).
    assign iTotClSess = oClSess:Length.

    for each ttAgent exclusive-lock:
        assign
            ttAgent.maxSessions = ?
            ttAgent.ablSessions = ?
            ttAgent.availSess   = ?
            ttAgent.openConns   = ?
            ttAgent.memoryBytes = ?
            .

        /* We should only obtain additional status and metrics if the MSAgent is available. */
        if ttAgent.agentState eq "available" then do:
            if lIsMin122 then do:
                /* Get the dynamic value for the available sessions of this MSAgent (available only to an instance running 12.2+). */
                oSessions = oMgrConn:GetDynamicSessionLimit(cAblApp, ttAgent.agentPID).
                if oSessions:Length ge 1 and JsonPropertyHelper:HasTypedProperty(oSessions:GetJsonObject(1), "ABLOutput", JsonDataType:object) then do:
                    oSessInfo = oSessions:GetJsonObject(1):GetJsonObject("ABLOutput"). /* Expects an array with at least 1 element (object). */

                    /* Should be the current calculated maximum # of ABL Sessions which can be started/utilized. */
                    if JsonPropertyHelper:HasTypedProperty(oSessInfo, "dynmaxablsessions", JsonDataType:Number) then
                        assign ttAgent.maxSessions = oSessInfo:GetInteger("dynmaxablsessions").

                    /* This should represent the total number of ABL Sessions started, not to exceed the Dynamic Max. */
                    if JsonPropertyHelper:HasTypedProperty(oSessInfo, "numABLSessions", JsonDataType:Number) then
                        assign ttAgent.ablSessions = oSessInfo:GetInteger("numABLSessions").

                    /* This should be the number of ABL Sessions available to execute ABL code for this MSAgent. */
                    if JsonPropertyHelper:HasTypedProperty(oSessInfo, "numAvailableSessions", JsonDataType:Number) then
                        assign ttAgent.availSess = oSessInfo:GetInteger("numAvailableSessions").
                end. /* session info array length ge 1 */
            end.

            /* Get threads for this particular MSAgent. */
            assign dStart = ?. /* Clear before use. */
            assign oThreads = oMgrConn:GetAgentThreads(cAblApp, ttAgent.agentPID).
            assign
                iTotThrd          = oThreads:Length
                ttAgent.startTime = dInstTime
                .

            /* Loop through the threads to get the earliest start time; should be the agent's epoch. */
            do iLoop2 = 1 to iTotThrd:
                assign oTemp = oThreads:GetJsonObject(iLoop2).
                if JsonPropertyHelper:HasTypedProperty(oTemp, "StartTime", JsonDataType:String) then
                    assign ttAgent.startTime = min(ttAgent.startTime, oTemp:GetDateTimeTZ("StartTime")).
            end. /* iLoop2 - oThreads */

            /* Attempt to calculate the time this session has been running, though we don't have a current timestamp directly from the server. */
            assign dStart = datetime(date(ttAgent.startTime), mtime(ttAgent.startTime)) when ttAgent.startTime ne ?.
            assign ttAgent.runningTime = interval(dInstTime, dStart, "milliseconds") when (dInstTime ne ? and dStart ne ? and dInstTime ge dStart).

            /* Get metrics about this particular MSAgent (expects an array with at least 1 element). */
            assign oStatHist = oMgrConn:GetAgentMetrics(cAblApp, ttAgent.agentPID).
            if oStatHist:Length ge 1 then do:
                oTemp = oStatHist:GetJsonObject(1).

                if JsonPropertyHelper:HasTypedProperty(oTemp, "OpenConnections", JsonDataType:Number) then
                    assign ttAgent.openConns = oTemp:GetInteger("OpenConnections").

                if JsonPropertyHelper:HasTypedProperty(oTemp, "OverheadMemory", JsonDataType:Number) then
                    assign ttAgent.memoryBytes = oTemp:GetInt64("OverheadMemory").
            end.

            /* Get sessions and count non-idle states. */
            assign dStart = ?. /* Clear before use. */
            assign oSessions = oMgrConn:GetAgentSessions(cAblApp, ttAgent.agentPID).
            assign iTotSess  = oSessions:Length.
            do iLoop2 = 1 to iTotSess:
                create ttAgentSession.
                assign
                    ttAgentSession.agentID        = ttAgent.agentID
                    ttAgentSession.agentPID       = ttAgent.agentPID
                    ttAgentSession.sessionID      = oSessions:GetJsonObject(iLoop2):GetInteger("SessionId")
                    ttAgentSession.sessionState   = oSessions:GetJsonObject(iLoop2):GetCharacter("SessionState")
                    ttAgentSession.startTime      = oSessions:GetJsonObject(iLoop2):GetDatetimeTZ("StartTime")
                    ttAgentSession.memoryBytes    = oSessions:GetJsonObject(iLoop2):GetInt64("SessionMemory")
                    ttAgentSession.memAtRestBytes = ttAgentSession.memoryBytes
                    ttAgentSession.memActiveBytes = ttAgentSession.memoryBytes
                    .

                if lIsMin127 then do:
                    /* Only expend the energy to extract these values when the instance is running version 12.7+ */

                    if JsonPropertyHelper:HasTypedProperty(oSessions:GetJsonObject(iLoop2), "MemAtRestHighWater", JsonDataType:Number) then
                        ttAgentSession.memAtRestBytes = max(ttAgentSession.memoryBytes, oSessions:GetJsonObject(iLoop2):GetInt64("MemAtRestHighWater")).

                    if JsonPropertyHelper:HasTypedProperty(oSessions:GetJsonObject(iLoop2), "MemActiveHighWater", JsonDataType:Number) then
                        ttAgentSession.memActiveBytes = max(ttAgentSession.memAtRestBytes, oSessions:GetJsonObject(iLoop2):GetInt64("MemActiveHighWater")).

                    if JsonPropertyHelper:HasTypedProperty(oSessions:GetJsonObject(iLoop2), "RequestsCompleted", JsonDataType:Number) then
                        ttAgentSession.reqCompleted = oSessions:GetJsonObject(iLoop2):GetInt64("RequestsCompleted").

                    if JsonPropertyHelper:HasTypedProperty(oSessions:GetJsonObject(iLoop2), "RequestsFailed", JsonDataType:Number) then
                        ttAgentSession.reqFailed = oSessions:GetJsonObject(iLoop2):GetInt64("RequestsFailed").
                end.

                /* Attempt to determine the most minimal memory value for all sessions of all agents available. */
                if iMinMem eq 0 then
                    assign iMinMem = ttAgentSession.memoryBytes.
                else
                    assign iMinMem = min(iMinMem, ttAgentSession.memoryBytes).

                /* Attempt to calculate the time this session has been running, though we don't have a current timestamp directly from the server. */
                assign dStart = datetime(date(ttAgentSession.startTime), mtime(ttAgentSession.startTime)) when ttAgentSession.startTime ne ?.
                assign ttAgentSession.runningTime = interval(dInstTime, dStart, "milliseconds") when (dInstTime ne ? and dStart ne ? and dInstTime ge dStart).

                if iTotClSess gt 0 then
                do iLoop = 1 to iTotClSess
                on error undo, leave:
                    assign oTemp = oClSess:GetJsonObject(iLoop).

                    if oTemp:Has("bound") and oTemp:GetLogical("bound") and
                       oTemp:GetCharacter("agentID") eq ttAgent.agentID and
                       integer(oTemp:GetCharacter("ablSessionID")) eq oSessions:GetJsonObject(iLoop2):GetInteger("SessionId") then
                        assign
                            ttAgentSession.boundSession = oTemp:GetCharacter("sessionID")
                            ttAgentSession.boundReqID   = oTemp:GetCharacter("requestID")
                            .
                end. /* iLoop - iTotClSess */

                release ttAgentSession no-error.
            end. /* iLoop2 - oSessions */
        end. /* agent state = available */
    end. /* for each ttAgent */

    for each ttAgent no-lock:
        /* Output all information for each MSAgent after displaying a basic header. */
        put unformatted substitute("~n> Agent PID &1: &2", ttAgent.agentPID, ttAgent.agentState) skip.

        if ttAgent.startTime ne ? then
            put unformatted substitute("~tEst. Agent Lifetime: &1", FormatMsTime(ttAgent.runningTime)) skip.

        if ttAgent.maxSessions ne ? then
            put unformatted substitute("~tDynMax ABL Sessions:~t    &1", FormatIntAsNumber(ttAgent.maxSessions)) skip.

        if ttAgent.ablSessions ne ? then
            put unformatted substitute("~t Total ABL Sessions:~t    &1", FormatIntAsNumber(ttAgent.ablSessions)) skip.

        if ttAgent.availSess ne ? then
            put unformatted substitute("~t Avail ABL Sessions:~t    &1", FormatIntAsNumber(ttAgent.availSess)) skip.

        if ttAgent.openConns ne ? then
            put unformatted substitute("~t   Open Connections:~t    &1", FormatIntAsNumber(ttAgent.openConns)) skip.

        if ttAgent.memoryBytes ne ? then
            put unformatted substitute("~t    Overhead Memory: &1 KB", FormatMemory(ttAgent.memoryBytes, true)) skip.

        if lIsMin127 then
            /* This version adds additional session metrics for active memory high-water mark and count of completed/failed requests. */
            put unformatted "~n~tSESSION ID~tSTATE~t~tSTARTED~t~t~t~tLIFETIME~t  SESS. MEMORY~t   ACTIVE MEM.~t REQUESTS~tBOUND/ACTIVE CLIENT SESSION" skip.
        else
            put unformatted "~n~tSESSION ID~tSTATE~t~tSTARTED~t~t~t~tLIFETIME~t  SESS. MEMORY~t BOUND/ACTIVE CLIENT SESSION" skip.

        assign iBaseMem = max(iBaseMem, iMinMem) + 1024. /* Use the higher of the BaseMem (Ant parameter) or discovered minimum memory, plus 1K. */

        assign
            iBusySess = 0
            iUsedSess = 0
            iTotSess  = 0
            iTotalMem = if ttAgent.memoryBytes ne ? then ttAgent.memoryBytes else 0
            .

        for each ttAgentSession no-lock
           where ttAgentSession.agentID eq ttAgent.agentID:
            if lIsMin127 then do:
                put unformatted substitute("~t~t&1~t&2~t&3~t&4 &5 KB &6 KB &7~t&8 &9",
                                            string(ttAgentSession.sessionID, ">>>9"),
                                            string(ttAgentSession.sessionState, "x(10)"),
                                            ttAgentSession.startTime,
                                            FormatMsTime(ttAgentSession.runningTime),
                                            FormatMemory(ttAgentSession.memAtRestBytes, false),
                                            FormatMemory(ttAgentSession.memActiveBytes, false),
                                            FormatLongNumber(string(ttAgentSession.reqCompleted), false),
                                            (if ttAgentSession.boundSession gt "" then ttAgentSession.boundSession else ""),
                                            (if ttAgentSession.boundReqID gt "" then "[" + ttAgentSession.boundReqID + "]" else "-")) skip.
            end.
            else do:
                put unformatted substitute("~t~t&1~t&2~t&3~t&4 &5 KB~t&6 &7",
                                            string(ttAgentSession.sessionID, ">>>9"),
                                            string(ttAgentSession.sessionState, "x(10)"),
                                            ttAgentSession.startTime,
                                            FormatMsTime(ttAgentSession.runningTime),
                                            FormatMemory(ttAgentSession.memAtRestBytes, false),
                                            (if ttAgentSession.boundSession gt "" then ttAgentSession.boundSession else ""),
                                            (if ttAgentSession.boundReqID gt "" then "[" + ttAgentSession.boundReqID + "]" else "-")) skip.
            end.

            assign
                iTotSess  = iTotSess + 1
                iTotalMem = iTotalMem + ttAgentSession.memActiveBytes
                .

            /* Busy sessions are those actively serving requests (non-IDLE). */
            if ttAgentSession.sessionState ne "IDLE" then
                assign iBusySess = iBusySess + 1.

            /**
             * Since iBaseMem should be the LOWEST value across all agents, it should theoretically be the baseline value
             * for any unused (fresh) sessions. Therefore, counting any sessions higher than this should indicate that the
             * session was utilized for servicing requests.
             */
            if ttAgentSession.memoryBytes gt iBaseMem then
                assign iUsedSess = iUsedSess + 1.
        end. /* for each ttAgentSession */

        /* Output summary information about agent-sessions, such as how many are busy out of the total count. */
        put unformatted substitute("~t  Active Agent-Sessions: &1 of &2 (&3% Busy)",
                                   iBusySess, iTotSess, if iTotSess gt 0 then round((iBusySess / iTotSess) * 100, 1) else 0) skip.

        /* Establish an educated guess on how many sessions have been utilized via a baseline memory value. */
        put unformatted substitute("~tUtilized Agent-Sessions: &1 of &2 (>&3 KB)", iUsedSess, iTotSess, FormatMemory(iBaseMem, true)) skip.

        /* For 12.2+ this should include agent overhead memory + all sessions, otherwise just all sessions. */
        put unformatted substitute("~t   Approx. Agent Memory: &1 KB", FormatMemory(iTotalMem, true)) skip.
    end. /* for each ttAgent */
end procedure.

/* Consults the SessionManager for a count of Client HTTP Sessions, along with stats on the Client Connections and Agent Connections. */
procedure GetSessions:
    define variable lIsBound  as logical    no-undo.
    define variable oConnInfo as JsonObject no-undo.
    define variable oTemp     as JsonObject no-undo.

    /* https://docs.progress.com/bundle/pas-for-openedge-management/page/Collect-runtime-metrics.html */
    put unformatted "~nSession Manager Metrics ".
    case iCollect:
        when 0 then put unformatted "(Not Enabled)" skip.
        when 1 then put unformatted "(Count-Based)" skip.
        when 2 then put unformatted "(Time-Based)" skip.
        when 3 then put unformatted "(Count+Time)" skip.
    end case.

    if valid-object(oMetrics) then do:
        /* Total number of requests to the session. */
        if JsonPropertyHelper:HasTypedProperty(oMetrics, "requests", JsonDataType:Number) then
            put unformatted substitute("~t       # Requests to Session: &1",
                                        FormatLongNumber(string(oMetrics:GetInteger("requests")), false)) skip.

        /* Number of times a response was read by the session from the MSAgent. */
        /* Number of errors that occurred while reading a response from the MSAgent. */
        if JsonPropertyHelper:HasTypedProperty(oMetrics, "reads", JsonDataType:Number) and
           JsonPropertyHelper:HasTypedProperty(oMetrics, "readErrors", JsonDataType:Number) then
            put unformatted substitute("~t      # Agent Responses Read: &1 (&2 Errors)",
                                        FormatLongNumber(string(oMetrics:GetInteger("reads")), false),
                                        trim(string(oMetrics:GetInteger("readErrors"), "->>>,>>>,>>9"))) skip.

        /* Minimum, maximum, average times to read a response from the MSAgent. */
        if JsonPropertyHelper:HasTypedProperty(oMetrics, "minAgentReadTime", JsonDataType:Number) and
           JsonPropertyHelper:HasTypedProperty(oMetrics, "maxAgentReadTime", JsonDataType:Number) and
           JsonPropertyHelper:HasTypedProperty(oMetrics, "avgAgentReadTime", JsonDataType:Number) then
            put unformatted substitute("~tAgent Read Time (Mn, Mx, Av): &1 / &2 / &3",
                                        FormatMsTime(oMetrics:GetInteger("minAgentReadTime")),
                                        FormatMsTime(oMetrics:GetInteger("maxAgentReadTime")),
                                        FormatMsTime(oMetrics:GetInteger("avgAgentReadTime"))) skip.

        /* Number of times requests were written by the session on the MSAgent. */
        /* Number of errors that occurred during writing a request to the MSAgent. */
        if JsonPropertyHelper:HasTypedProperty(oMetrics, "writes", JsonDataType:Number) and
           JsonPropertyHelper:HasTypedProperty(oMetrics, "writeErrors", JsonDataType:Number) then
            put unformatted substitute("~t    # Agent Requests Written: &1 (&2 Errors)",
                                        FormatLongNumber(string(oMetrics:GetInteger("writes")), false),
                                        trim(string(oMetrics:GetInteger("writeErrors"), "->>>,>>>,>>9"))) skip.

        /* Number of clients connected at a particular time. */
        /* Maximum number of concurrent clients. */
        if JsonPropertyHelper:HasTypedProperty(oMetrics, "concurrentConnectedClients", JsonDataType:Number) and
           JsonPropertyHelper:HasTypedProperty(oMetrics, "maxConcurrentClients", JsonDataType:Number) then
            put unformatted substitute("~tConcurrent Connected Clients: &1 (Max: &2)",
                                        FormatLongNumber(string(oMetrics:GetInteger("concurrentConnectedClients")), false),
                                        trim(string(oMetrics:GetInteger("maxConcurrentClients"), "->>>,>>>,>>9"))) skip.

        /* Total time that reserved ABL sessions had to wait before executing. */
        if JsonPropertyHelper:HasTypedProperty(oMetrics, "totReserveABLSessionWaitTime", JsonDataType:Number) then
            put unformatted substitute("~tTot. Reserve ABLSession Wait: &1", FormatMsTime(oMetrics:GetInteger("totReserveABLSessionWaitTime"))) skip.

        /* Number of waits that occurred while reserving a local ABL session. */
        if JsonPropertyHelper:HasTypedProperty(oMetrics, "numReserveABLSessionWaits", JsonDataType:Number) then
            put unformatted substitute("~t  # Reserve ABLSession Waits: &1", FormatLongNumber(string(oMetrics:GetInteger("numReserveABLSessionWaits")), false)) skip.

        /* Average time that a reserved ABL session had to wait before executing. */
        if JsonPropertyHelper:HasTypedProperty(oMetrics, "avgReserveABLSessionWaitTime", JsonDataType:Number) then
            put unformatted substitute("~tAvg. Reserve ABLSession Wait: &1", FormatMsTime(oMetrics:GetInteger("avgReserveABLSessionWaitTime"))) skip.

        /* Maximum time that a reserved ABL session had to wait before executing. */
        if JsonPropertyHelper:HasTypedProperty(oMetrics, "maxReserveABLSessionWaitTime", JsonDataType:Number) then
            put unformatted substitute("~tMax. Reserve ABLSession Wait: &1", FormatMsTime(oMetrics:GetInteger("maxReserveABLSessionWaitTime"))) skip.

        /* Number of timeouts that occurred while reserving a local ABL session. */
        if JsonPropertyHelper:HasTypedProperty(oMetrics, "numReserveABLSessionTimeouts", JsonDataType:Number) then
            put unformatted substitute("~t# Reserve ABLSession Timeout: &1", FormatLongNumber(string(oMetrics:GetInteger("numReserveABLSessionTimeouts")), false)) skip.
    end. /* valid oMetrics */

    /* Parse through and display statistics from the Client Sessions API as obtained previously. */
    put unformatted substitute("~nClient HTTP Sessions: &1", iTotClSess) skip.

    if iTotClSess gt 0 then do:
        put unformatted "~tSTATE     SESS STATE  BOUND~tLAST ACCESS / STARTED~t~tELAPSED TIME  SESSION MODEL    ADAPTER   SESSION ID~t~t~t~t~t~t~tREQUEST ID" skip.

        if iTotClSess gt 0 then
        SESSIONBLK:
        do iLoop = 1 to iTotClSess
        on error undo, throw:
            /* There should always be a session present, so output that first. */
            assign oTemp = oClSess:GetJsonObject(iLoop).

            /* If we have elements in the ClientSession array, then each should be a valid object. But just in case it's not valid, skip. */
            if not valid-object(oTemp) then next SESSIONBLK.

            assign lIsBound = false. /* Reset for each iteration. */
            if JsonPropertyHelper:HasTypedProperty(oTemp, "bound", JsonDataType:Boolean) then
                assign lIsBound = oTemp:GetLogical("bound") eq true.

            put unformatted substitute("~n~t&1&2&3~t&4~t&5  &6 &7&8 &9",
                                       string(oTemp:GetCharacter("requestState"), "x(10)"),
                                       string(oTemp:GetCharacter("sessionState"), "x(12)"),
                                       string(lIsBound, "YES/NO"),
                                       oTemp:GetCharacter("lastAccessStr"),
                                       FormatMsTime(oTemp:GetInt64("elapsedTimeMs")),
                                       string(oTemp:GetCharacter("sessionType"), "x(16)"),
                                       string(oTemp:GetCharacter("adapterType"), "x(10)"),
                                       string(oTemp:GetCharacter("sessionID"), "x(60)"),
                                       oTemp:GetCharacter("requestID")) skip.

            assign cBound = "". /* Reset on each iteration. */

            /* For bound sessions, prepare info about the agent-session against which the connection exists. */
            if lIsBound and oTemp:Has("agentID") and oTemp:Has("ablSessionID") then do:
                if oAgentMap:ContainsKey(oTemp:GetCharacter("agentID")) then
                    /* We have a matching agent in existence, so return its PID with the ABLSession. */
                    assign cBound = string(oAgentMap:Get(oTemp:GetCharacter("agentID"))) + " #" + oTemp:GetCharacter("ablSessionID").
                else if (oTemp:GetCharacter("agentID") gt "") eq true then
                    /* There is no matching PID, but we're bound and have an AgentID and ABLSession. */
                    assign cBound = "[PID Unknown] #" + oTemp:GetCharacter("ablSessionID").
            end. /* bound */

            /* Client Connections should be present next, especially if session-managed model is used. */
            if JsonPropertyHelper:HasTypedProperty(oTemp, "clientConnInfo", JsonDataType:object) then do:
                assign oConnInfo = oTemp:GetJsonObject("clientConnInfo").

                if valid-object(oConnInfo) then
                    put unformatted substitute("~t|- ClientConn: &1~t&2~t&3  Proc: &4 &5",
                                               if oConnInfo:Has("clientName") then oConnInfo:GetCharacter("clientName") else "UNKNOWN",
                                               if oConnInfo:Has("reqStartTimeStr") then oConnInfo:GetCharacter("reqStartTimeStr") else "UNKNOWN",
                                               FormatMsTime(if oConnInfo:Has("elapsedTimeMs") then oConnInfo:GetInt64("elapsedTimeMs") else 0),
                                               string(if oConnInfo:Has("requestProcedure") then oConnInfo:GetCharacter("requestProcedure") else "", "x(40)"),
                                               if cBound gt "" then "Agent-Session: " + cBound else "") skip.
            end. /* clientConnInfo */

            /* Agent Connection should be present if executing ABL code. */
            if JsonPropertyHelper:HasTypedProperty(oTemp, "agentConnInfo", JsonDataType:object) then do:
                assign oConnInfo = oTemp:GetJsonObject("agentConnInfo").

                /* We can't really continue unless there is an AgentID (string) value to display. */
                if JsonPropertyHelper:HasTypedProperty(oConnInfo, "agentID", JsonDataType:string) then
                    put unformatted substitute("~t|-- AgentConn: &1  &2  Agent: &3  Local: &4",
                                               if oAgentMap:ContainsKey(oConnInfo:GetCharacter("agentID"))
                                               then "PID " + oAgentMap:Get(oConnInfo:GetCharacter("agentID"))
                                               else "ID " + oConnInfo:GetCharacter("agentID"),
                                               /* Omitted connID and conPoolID */
                                               if oConnInfo:Has("state") then oConnInfo:GetCharacter("state") else "UNKNOWN",
                                               if oConnInfo:Has("agentAddr") then oConnInfo:GetCharacter("agentAddr") else "NA",
                                               if oConnInfo:Has("localAddr") then oConnInfo:GetCharacter("localAddr") else "NA") skip.
            end. /* agentConnInfo */

            catch err as Progress.Lang.Error:
                message substitute("Encountered error displaying Client Session &1 of &2: &3", iLoop, iTotClSess, err:GetMessage(1)).
                if valid-object(oConnInfo) then /* Output JSON data for investigation. */
                    oClSess:WriteFile(substitute(session:temp-directory + "ClientSession_&1.json", cOutDate), true).
                next SESSIONBLK.
            end catch.
        end. /* iLoop */
    end. /* response - ClientSessions */
end procedure.
