/**************************************************************************
Copyright (c) 2023 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/**
 * Author(s): Dustin Grau (dugrau@progress.com)
 *
 * Obtains table lock info and running programs against a PASOE instance.
 * Usage: getLocks.p <params>
 *  Parameter Default/Allowed
 *   Scheme   [http|https]
 *   Hostname [localhost]
 *   PAS Port [8810]
 *   UserId   [tomcat]
 *   Password [tomcat]
 *   ABL App  [oepas1]
 */

block-level on error undo, throw.

using OpenEdge.ApplicationServer.Util.OEManagerConnection.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.Collections.Array.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.Collections.StringStringMap.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.

define variable cClSessID   as character       no-undo.
define variable oTemp       as JsonObject      no-undo.
define variable oAblApps    as Array           no-undo.
define variable oAgentIDs   as StringStringMap no-undo.
define variable oAppAgents  as StringStringMap no-undo.
define variable oAgentList  as Array           no-undo.
define variable oSessions   as JsonArray       no-undo.
define variable oABLStacks  as JsonArray       no-undo.
define variable oABLStack   as JsonObject      no-undo.
define variable oCallstack  as JsonArray       no-undo.
define variable cDB         as character       no-undo.
define variable iLoop       as integer         no-undo.
define variable iLoop2      as integer         no-undo.
define variable iStacks     as integer         no-undo.
define variable iSessions   as integer         no-undo.
define variable iCStacks    as integer         no-undo.
define variable iPID        as integer         no-undo.
define variable oIter       as IIterator       no-undo.
define variable oAgent      as IMapEntry       no-undo.

/* Manage the server connection to the OEManager webapp */
define variable oMgrConn  as OEManagerConnection no-undo.
define variable cScheme   as character           no-undo initial "http".
define variable cHost     as character           no-undo initial "localhost".
define variable cPort     as character           no-undo.
define variable cUserId   as character           no-undo.
define variable cPassword as character           no-undo.

function HasAgent returns logical ( input poInt as integer ) forward.

define temp-table ttLock no-undo
    field UserNum      as int64
    field UserName     as character
    field DomainName   as character
    field TenantName   as character
    field DatabaseName as character
    field TableName    as character
    field LockFlags    as character
    field TransID      as int64
    field PID          as int64
    field SessionID    as int64
    .

/* Check for passed-in arguments/parameters. */
if num-entries(session:parameter) ge 5 then
    assign
        cScheme   = entry(1, session:parameter)
        cHost     = entry(2, session:parameter)
        cPort     = entry(3, session:parameter)
        cUserId   = entry(4, session:parameter)
        cPassword = entry(5, session:parameter)
        .
else
    assign
        cScheme   = dynamic-function("getParameter" in source-procedure, "Scheme") when (dynamic-function("getParameter" in source-procedure, "Scheme") gt "") eq true
        cHost     = dynamic-function("getParameter" in source-procedure, "Host") when (dynamic-function("getParameter" in source-procedure, "Host") gt "") eq true
        cPort     = dynamic-function("getParameter" in source-procedure, "Port") when (dynamic-function("getParameter" in source-procedure, "Port") gt "") eq true
        cUserId   = dynamic-function("getParameter" in source-procedure, "UserID") when (dynamic-function("getParameter" in source-procedure, "UserID") gt "") eq true
        cPassword = dynamic-function("getParameter" in source-procedure, "PassWD") when (dynamic-function("getParameter" in source-procedure, "PassWD") gt "") eq true
        .

/* Create and OEManager connection for API calls. */
assign oMgrConn = OEManagerConnection:Build(cScheme, cHost, integer(cPort), cUserId, cPassword).
assign
    oAblApps   = new Array()
    oAgentIDs  = new StringStringMap()
    oAppAgents = new StringStringMap()
    oAgentList = new Array()
    .

oAblApps:AutoExpand = true.
oAgentList:AutoExpand = true.

/* Populate temp-table with table lock status. */
message "~nScanning for Table Locks from connected PASN clients...".
DBLOOP:
do iLoop = 1 to num-dbs:
    assign cDB = ldbname(iLoop).
    if cDB eq ? then next DBLOOP.

    /* Change to the next DB by setting the "dictdb" alias. */
    create alias dictdb for database value(cDB).

    /* Scan all locks for this DB */
    message substitute("~tGetting lock stats for &1...", cDB).
    run OpenEdge/ApplicationServer/Cli/getLockStats.p (input-output table ttLock by-reference).
end.

/* Display table lock information to screen. */
message "~nUser #~tUser Name~t~t~tDomain~t~t~tTenant~t~tDatabase~t~t~t~t~t~t~tTable~t~t~tFlags~t~t~t    PID~t SessionID".
for each ttLock no-lock:
    message substitute("&1~t&2 &3 &4 &5 &6 &7 &8  &9",
                       string(ttLock.UserNum) + fill(" ", 10 - length(string(ttLock.UserNum))),
                       string(ttLock.UserName, "x(31)"),
                       string(ttLock.DomainName, "x(23)"),
                       string(ttLock.TenantName, "x(15)"),
                       string(ttLock.DatabaseName, "x(63)"),
                       string(ttLock.TableName, "x(23)"),
                       string(ttLock.LockFlags, "x(15)"),
                       string(ttLock.PID, ">>>>>>>>>>>>>>9"),
                       (if ttLock.SessionID eq ? then "UNKNOWN" else string(ttLock.SessionID, ">>>>>>>>9"))).

    /****************************************************************************************************
      Lock Types
        X   Exclusive Lock
        S   Share Lock
        IX  Intent Exclusive Lock
        IS  Intent Share Lock
        SIX Shared lock on table with intent to set exclusive locks on records

      Lock Flags (https://knowledgebase.progress.com/articles/Article/21639):
        C   Create              The lock is in create mode.
        D   Downgrade           The lock is downgraded.
        E   Expired             The lock wait timeout has expired on this queued lock.
        H   On Hold             The "onhold" flag is set.
        J   JTA                 The lock is part of a JTA transaction
        K   Keep                Keep the lock across transaction end boundary
        L   Limbo Lock          The client has released the record, but the transaction has not completed.
                                (The record lock is not released until the transaction ends.)
        P   Purged Lock entry   The lock is no longer held.
        Q   Queued Lock req.    Represents a queued request for a lock already held by another process.
        U   Upgrade Request     The user has requested a lock upgrade from SHARE to EXCLUSIVE.
    ****************************************************************************************************/

    /* Track a list of PID's which relate to locked tables (by PASN users). */
    oAgentList:Add(new OpenEdge.Core.Integer(ttLock.PID)).
end.

/* Get information on PAS instance. */
run getAblApplications.
run getAblAppAgents.

/* Iterate through the list of ABL App MSAgents, getting stacks for those with table locks. */
assign oIter = oAppAgents:EntrySet:Iterator().
do while oIter:HasNext():
    assign oAgent = cast(oIter:Next(), IMapEntry).
    assign iPID = integer(string(oAgent:key)). /* Key for StringStringMap is just a PID. */

    /* Obtain stacks for the agent. */
    if HasAgent(iPID) then do:
        /* First, get client sessions for this ABL Application (StringStringMap is PID:ABLAppName). */
        assign oSessions = oMgrConn:GetClientSessions(string(oAgent:value)).
        assign iSessions = oSessions:Length.

        /* Next, get the stacks for this instance, ABL App, and PID. */
        message substitute("~n&1 MSAgent PID &2:", string(oAgent:value), iPID).
        assign oABLStacks = oMgrConn:GetAgentStacks(string(oAgent:value), iPID).
        assign iStacks = oABLStacks:Length.
        do iLoop = 1 to iStacks:
            assign
                oABLStack = oABLStacks:GetJsonObject(iLoop)
                cClSessID = ""
                .

            if oABLStack:Has("AgentSessionId") then do:
                SESSION-LOOP:
                do iLoop2 = 1 to iSessions:
                    /* Attempt to find a [client] session ID for this Agent-Session; needed to terminate a connection if necessary. */
                    /* Applies mostly to APSV, and should be only 1 connection per agent-session, so there will be a unique result. */
                    assign oTemp = oSessions:GetJsonObject(iLoop2).
                    if oTemp:Has("agentID") and oTemp:Has("sessionID") and oTemp:Has("ablSessionID") and
                       oAgentIDs:ContainsKey(string(oAgent:key)) and oTemp:GetCharacter("agentID") eq oAgentIDs:Get(string(oAgent:key)) and
                       integer(oTemp:GetCharacter("ablSessionID")) eq oABLStack:GetInteger("AgentSessionId") then do:
                        assign cClSessID = oTemp:GetCharacter("sessionID").
                        leave SESSION-LOOP.
                    end.
                end. /* iLoop2 */

                if cClSessID gt "" then
                    message substitute("~n~tCall Stack for Session ID #&1 (&2):", oABLStack:GetInteger("AgentSessionId"), cClSessID).
                else
                    message substitute("~n~tCall Stack for Session ID #&1:", oABLStack:GetInteger("AgentSessionId")).
            end. /* Has AgentSessionId */

            if JsonPropertyHelper:HasTypedProperty(oABLStack, "Callstack", JsonDataType:Array) then do:
                assign oCallstack = oABLStack:GetJsonArray("Callstack").

                assign iCStacks = oCallstack:Length.
                do iLoop2 = 1 to iCStacks:
                    if oCallstack:GetJsonObject(iLoop2):Has("Routine") then
                        message substitute("~t~t&1", oCallstack:GetJsonObject(iLoop2):GetCharacter("Routine")).
                end. /* iLoop2 */
            end. /* Has Callstack*/
        end. /* iLoop */
    end. /* oAgentList:Contains(iPID) */
end. /* do while */

finally:
    delete alias dictdb.

    /* Return value expected by PCT Ant task. */
    {&_proparse_ prolint-nowarn(returnfinally)}
    return string(0).
end finally.

/* PROCEDURES / FUNCTIONS */

function HasAgent returns logical (input poInt as integer):
    define variable lFound as logical no-undo initial false.
    define variable iMax   as integer no-undo.
    define variable iX     as integer no-undo.

    assign iMax = oAgentList:Size.
    do iX = 1 to iMax while not lFound:
        if valid-object(oAgentList:GetValue(iX)) then
            assign lFound = oAgentList:GetValue(iX):Equals(new OpenEdge.Core.Integer(poInt)).
    end.

    return lFound.
end function.

procedure getAblApplications:
    /* Obtain a list of all ABL Applications for a PAS instance. */
    define variable oApps as JsonArray  no-undo.
    define variable oApp  as JsonObject no-undo.

    assign oApps = oMgrConn:GetApplications().
    if oApps:Length gt 0 then
    APPBLK:
    do iLoop = 1 to oApps:Length
    on error undo, next APPBLK
    on stop undo, next APPBLK:
        /* Extract the name for each ABL App (type must be OPENEDGE). */
        oApp = oApps:GetJsonObject(iLoop).
        if oApp:Has("name") and oApp:Has("type") and oApp:GetCharacter("type") eq "OPENEDGE" then
            oAblApps:Add(new OpenEdge.Core.String(oApp:GetCharacter("name"))).
    end. /* iLoop - Application */
end procedure.

procedure getAblAppAgents:
    define variable iSize     as integer    no-undo.
    define variable cAppName  as character  no-undo.
    define variable oAgents   as JsonArray  no-undo.
    define variable oAgentObj as JsonObject no-undo.

    /* Iterate through the list of ABL Applications, getting all MSAgent PID's. */
    assign iSize = oAblApps:Size.
    do iLoop = 1 to iSize:
        if valid-object(oAblApps:GetValue(iLoop)) then do:
            /* Obtain a list of all AVAILABLE agents for an ABL Application. */
            assign cAppName = string(cast(oAblApps:GetValue(iLoop), OpenEdge.Core.String):Value).

            assign oAgents = oMgrConn:GetAgents(cAppName).
            if oAgents:Length gt 0 then
            AGENTBLK:
            do iLoop2 = 1 to oAgents:Length
            on error undo, next AGENTBLK
            on stop undo, next AGENTBLK:
                oAgentObj = oAgents:GetJsonObject(iLoop2).

                if oAgentObj:GetCharacter("state") eq "available" then do:
                    oAgentIDs:Put(oAgentObj:GetCharacter("pid"), oAgentObj:GetCharacter("agentId")).
                    oAppAgents:Put(oAgentObj:GetCharacter("pid"), cAppName).
                end.
            end. /* iLoop - agents */
        end. /* Non-Null Array Item */
    end. /* iLoop */
end procedure.
