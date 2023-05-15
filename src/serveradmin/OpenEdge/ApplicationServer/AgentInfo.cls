/**************************************************************************
Copyright (c) 2014,2017-2018,2021-2022 by Progress Software Corporation. All rights reserved.
**************************************************************************/
 /*------------------------------------------------------------------------
    File        : AgentInfo.cls
    Description : Used by the Server Broker tools to manage the agent & sessions.
    Author(s)   : aherbstr, dugrau
    Created     : Tuesday July 8 2014
    Notes       : Requests originate from Java MBeans which are utilized by the
                  OEJMX utility or oemanager WebApp via the following sources:
                    pasoe/com.progress.appserv.clientrt/
                        src/main/java/com/progress/appserv/clientrt/admin/
                            AdminConstants.java (CLASS_AGENTINFO)
                            AgentAdminUtil.java
                    pasoe/com.progress.appserv.manager/
                        src/main/java/com/progress/appserv/manager/admin/
                            AgentManager.java
                            AgentAdminUtil.java
                        src/main/java/com/progress/appserv/manager/jmx/
                            AgentManagerJmx.java
                            BrokerServiceManagerJmx.java
                        src/main/java/com/progress/appserv/manager/rest/
                            AgentManagerService.java
                            BrokerManagerService.java

                  The ABL code utilizes Progress.ApplicationServer.* classes written in C:
                    src/biosys/biopasainit.c (CLASS Progress.ApplicationServer.AgentInfo)
                    src/biosys/biopasa.c (bioPASAgentInfo)
  -----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.File.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.Logger.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.TokenResolver.
using OpenEdge.Logging.VoidLogger.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Format.FullTextFormat.
using OpenEdge.Logging.Writer.NamedFileWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.ObjectModelParser.

class OpenEdge.ApplicationServer.AgentInfo final:

    // Utilize the ABL Logger framework for customized logging abilities.
    define public property Logger as ILogWriter no-undo
    get():
        if not valid-object(this-object:Logger) then
        do on error undo, leave:
            /**
             * In order to minimize effects on this class, we want to utilize the bare miniumum
             * for the ABL Logger framework--this means avoiding some of the static registries
             * and builder libraries for generic Logger creation. We can accomplish this by
             * use of directly creating the object instances, and standardizing the output in a
             * predictible location via a preset log file path/name and a standard output format.
             * The only option we need from the standard logging.config and its JSON-formatted
             * structure is the logLevel property for the named logger object.
             *
             * Sample Log File: C:\OpenEdge\WRK\oepas1\temp\AgentInfo-A5309.log
             *
             * To enable logging output set the logLevel to DEBUG or higher.
             * Sample JSON for logging.config file:
             *   {
             *       "logger": {
             *           "OpenEdge.ApplicationServer.AgentInfo": {
             *               "logLevel": "DEBUG"
             *           }
             *       }
             *   }
             */
            define variable cLogType  as character     no-undo initial "OpenEdge.ApplicationServer.AgentInfo".
            define variable cLogFile  as character     no-undo initial "$~{session.temp-dir}/AgentInfo-A$~{req.agent}.log".
            define variable cLogLevel as character     no-undo.
            define variable oFile     as File          no-undo.
            define variable oConfig   as JsonObject    no-undo.
            define variable oLogLevel as LogLevelEnum  no-undo.
            define variable oFilters  as ILoggerFilter no-undo extent 2. // We know exactly how many filters are needed.

            // We need to read the config file but we only care about specific properties.
            assign oFile = new File("logging.config":u).
            if oFile:exists and oFile:CanRead then do:
                assign oConfig = cast(new ObjectModelParser():ParseFile(oFile:AbsolutePath()), JsonObject).
                if JsonPropertyHelper:HasTypedProperty(oConfig, "logger":u, JsonDataType:Object) then
                    if JsonPropertyHelper:HasTypedProperty(oConfig:GetJsonObject("logger":u), cLogType, JsonDataType:Object) then do:
                        if JsonPropertyHelper:HasTypedProperty(oConfig:GetJsonObject("logger":u):GetJsonObject(cLogType), "logLevel":u, JsonDataType:String) then
                            assign cLogLevel = oConfig:GetJsonObject("logger":u):GetJsonObject(cLogType):GetCharacter("logLevel":u).
                            assign oLogLevel = LogLevelEnum:GetEnum(cLogLevel) no-error. // Must use a no-error here.
                    end.
            end. // Config File Exists, Is Readable

            // Set the default logging level if we could not establish this from the config.
            if not valid-object(oLogLevel) then
                assign oLogLevel = LogLevelEnum:Default.

            // Manually create a logger instance using 2 filters:
            //  FullTextFormat  - Provides a common and expected log format with timestamp.
            //  NamedFileWriter - Writes to an agent-specific logfile in the session temp-dir.
            oFilters[1] = new FullTextFormat(). // Use a common log format with timestamp.
            oFilters[2] = new NamedFileWriter(TokenResolver:Resolve(cLogFile), true).
            this-object:Logger = new Logger(cLogType, oLogLevel, oFilters).

            {&_proparse_ prolint-nowarn(varusage)}
            catch uncaught as Progress.Lang.Error:
                // Swallow any logging errors, as we don't care and must not impede the admin request.
            end catch.
            finally:
                // For cases where an error may have been generated.
                assign error-status:error = false.
            end finally.
        end. // not valid-object

        // Create a void logger if we did not produce a valid logger.
        if not valid-object(this-object:Logger) then
            this-object:Logger = new VoidLogger(cLogType).

        return this-object:Logger.
    end get.
    private set.

    /* Constructor */
    constructor public AgentInfo ( ):
        this-object:logMessage(substitute("Creating AgentInfo Instance [&1]":u, proversion(1))).

        setArchiveAgentStats(true).
    end constructor.

    /* Destructor */
    destructor AgentInfo ( ):
        this-object:logMessage("Destroying AgentInfo Instance").

        setArchiveAgentStats(false).

        finally:
            if valid-object(this-object:Logger) then
                delete object this-object:Logger.
        end finally.
    end destructor.

    method private void logMessage ( input msg as character ):
        // Write to the configured ABL logger, or log-manager if the former is not available.
        if valid-object(this-object:Logger) then
            this-object:Logger:Debug(msg).
        else if log-manager:logging-level ge 4 then
            message msg.

        {&_proparse_ prolint-nowarn(varusage)}
        catch uncaught as Progress.Lang.Error:
            // Swallow any logging errors, as we don't care and must not impede the admin request.
        end catch.
    end method.

    /* Empties the cached agent request stats */
    method public void clearAgentStatData ( ):
        // AgentManager.java: clearAgentStatData
        // biopasa.c: OTM_PASAGENTINFO_GETREQUESTTABLE_ID -> bioPASAgentCreateTables

        define variable statsData as handle no-undo.

        this-object:logMessage("clearAgentStatData").

        /* Clear the agent request table */
        Progress.ApplicationServer.AgentInfo:getAgentRequestTableHandle(output statsData).
        if valid-handle(statsData) then
            statsData:empty-temp-table().
    end method.

    /* Toggles the agent stats archive on and off. If we turn gathering
       stats OFF (a FALSE parameter) then we also empty the cached stats

       @param logical TRUE to enabled archiving; FALSE to disable
       @return logical TRUE when stats are archived, FALSE otherwise */
    method public logical setArchiveAgentStats (input setValue as logical):
        // AgentManager.java: setArchiveAgentStats
        // biopasa.c: OTM_PASAGENTINFO_AGENTSTATS_ID -> bioPASAgentCreateTables

        this-object:logMessage(substitute("setArchiveAgentStats - SetValue[&1]":u, setValue)).

        Progress.ApplicationServer.AgentInfo:archiveAgentStats = setValue.

        if not Progress.ApplicationServer.AgentInfo:archiveAgentStats then
            clearAgentStatData().

        return Progress.ApplicationServer.AgentInfo:archiveAgentStats.
    end method.

    /* Returns the agent statistics

       @param table-handle Agent statistics data
       @return logical Valid table-handle present */
    method public logical getAgentStatData (output table-handle pasThandle):
        // AgentManager.java: getAgentStatus
        // biopasa.c: OTM_PASAGENTINFO_GETSTATTABLE_ID -> bioPASAgentCreateTables

        this-object:logMessage("getAgentStatData").

        Progress.ApplicationServer.AgentInfo:getAgentstatTableHandle(output pasThandle).

        return valid-handle(pasThandle).
    end method.

    /* Return current agent thread data

       @param table-handle Agent thread data
       @return logical Valid table-handle present */
    method public logical getAgentThreadData (output table-handle pasThandle):
        // AgentManager.java: getThreadMetrics
        // biopasa.c: OTM_PASAGENTINFO_GETTHREADTABLE_ID -> bioPASAgentCreateTables

        this-object:logMessage("getAgentThreadData").

        Progress.ApplicationServer.AgentInfo:getAgentThreadTableHandle(output pasThandle).

        return valid-handle(pasThandle).
    end method.

    /* Returns the status of all agent sessions

       @param table-handle Agent session data
       @return logical Valid table-handle present */
    method public logical getAgentSessionData (output table-handle pasThandle):
        // AgentManager.java: getSessionMetrics
        // biopasa.c: OTM_PASAGENTINFO_GETSESSIONTABLE_ID -> bioPASAgentCreateTables

        this-object:logMessage("getAgentSessionData").

        Progress.ApplicationServer.AgentInfo:getAgentSessionTableHandle(output pasThandle).

        return valid-handle(pasThandle).
    end method.

    /* Returns the status of a specific agent session

       @param character Agent SessionID
       @param table-handle Agent session data
       @return logical Valid table-handle present */
    method public logical getAgentSessionData (input  agentSessId as integer,
                                               output table-handle hTTCopy):
        // AgentManager.java: getSingleSessionMetrics
        // biopasa.c: OTM_PASAGENTINFO_GETSESSIONTABLE_ID -> bioPASAgentCreateTables

        define variable hTTSrcBuffer  as handle no-undo.
        define variable hTTCopyBuffer as handle no-undo.
        define variable pasThandle    as handle no-undo.

        this-object:logMessage(substitute("getAgentSessionData - AgentSessID[&1]":u, agentSessId)).

        Progress.ApplicationServer.AgentInfo:getAgentSessionTableHandle(output pasThandle).

        /* Create dynamic temp-table */
        create temp-table hTTCopy.

        /* Copy the schema from the one passed in */
        hTTCopy:create-like(pasThandle).

        /* Get the new temp-table ready and name it AgentSession */
        hTTCopy:temp-table-prepare("AgentSession").

        /* Get the default buffer for both source and target tables */
        assign
            hTTSrcBuffer  = pasThandle:default-buffer-handle
            hTTCopyBuffer = hTTCopy:default-buffer-handle
            .

        /* Fetch specific record from source table where session ID matches */
        hTTSrcBuffer:find-first(substitute("where &1._Session-Id eq &2":u, pasThandle:name, agentSessId)) no-error.
        if hTTSrcBuffer:available then do:
            /* Create record and copy from source */
            hTTCopyBuffer:buffer-create().
            hTTCopyBuffer:buffer-copy(hTTSrcBuffer).
            hTTCopyBuffer:buffer-release().
        end.

        return valid-handle(hTTCopy).

        finally:
            delete object hTTCopy.
        end finally.
    end method.

    /* Returns the agent connection data

       @param table-handle Agent connection data
       @return logical Valid table-handle present */
    method public logical getAgentConnectionData (output table-handle pasThandle):
        // AgentManager.java: getConnectionMetrics
        // biopasa.c: OTM_PASAGENTINFO_GETCONNECTTABLE_ID -> bioPASAgentCreateTables

        this-object:logMessage("getAgentConnectionData").

        Progress.ApplicationServer.AgentInfo:getAgentConnectionTableHandle(output pasThandle).

        return valid-handle(pasThandle).
    end method.

    /* Returns the last 1000 requests for this agent

       This method used to give all the requests that are running on the agent.
       But because of the Issue:PSC00364863, we limited the API to return only
       last 1000 requests information.

       @param table-handle Agent request data
       @return logical Valid table-handle present */
    method public logical getAgentRequestData (output table-handle hTTCopy):
        // AgentManager.java: getRequestMetrics
        // biopasa.c: OTM_PASAGENTINFO_GETREQUESTTABLE_ID -> bioPASAgentCreateTables

        define variable hTTSrcBuffer  as handle  no-undo.
        define variable hTTCopyBuffer as handle  no-undo.
        define variable hQuery        as handle  no-undo.
        define variable iCounter      as integer no-undo.
        define variable pasThandle    as handle  no-undo.

        this-object:logMessage("getAgentConnectionData").

        Progress.ApplicationServer.AgentInfo:getAgentRequestTableHandle(output pasThandle).

        /* Create dynamic temp-table */
        create temp-table hTTCopy.

        /* Copy the schema from the one passed in */
        hTTCopy:create-like(pasThandle).

        /* Get it ready and name it - in this case, AgentRequest is the new temp-table name */
        hTTCopy:temp-table-prepare("AgentRequest").

        /* Get the default buffer for both source and target tables */
        assign
            hTTSrcBuffer  = pasThandle:default-buffer-handle
            hTTCopyBuffer = hTTCopy:default-buffer-handle
            .

        /* scan the source temp-table, in reverse order, and copy only the last
           1000 records. First create query to fetch records from source table */
        create query hQuery.
        hQuery:set-buffers(hTTSrcBuffer).
        hQuery:query-prepare(substitute("for each &1":u, pasThandle:name)).
        hQuery:query-open().
        /* get last one, to do reverse fetching */
        hQuery:get-last().

        /* loop through until query returns no more records */
        do while not hQuery:query-off-end:
            iCounter = iCounter + 1.

            /* Create record and copy from source */
            hTTCopyBuffer:buffer-create().
            hTTCopyBuffer:buffer-copy(hTTSrcBuffer).
            hTTCopyBuffer:buffer-release().

            /* Stop when we create 100 records */
            if iCounter = 1000 then
            COUNTBLK:
            do:
                leave COUNTBLK.
            end.

            /* get previous record */
            hQuery:get-prev().
        end.

        return valid-handle(hTTCopy).

        finally:
            if valid-object(hQuery) then
            do:
                if hQuery:is-open then
                    hQuery:query-close.
                delete object hQuery no-error.
            end.

            delete object hTTCopy.
        end finally.
    end method.

    /* Returns the agent call stack for all sessions

       @param longchar JSON representation of the stack information
       @return logical Success/Failure */
    method public logical getAgentStacks (output pStacks as longchar):
        // AgentManager.java: getAgentStacks
        // biopasa.c: OTM_PASAGENTINFO_GETAGENTSTACKS_ID -> csMtPasGetAgentStacks

        define variable mptr as memptr no-undo.
        define variable retVal as logical no-undo.

        this-object:logMessage("getAgentStacks").

        assign retVal = Progress.ApplicationServer.AgentInfo:GetAgentStacks(mptr).

        copy-lob from mptr
                 // JSON data is spec'ed as UTF-8
                 to pStacks convert target codepage 'utf-8':u.

        return retVal.

        finally:
            set-size(mptr) = 0.
        end finally.
    end method.

    /* Returns the agent dynamic ABL session limit

       @param longchar JSON representation of the session information
       @return logical Success/Failure */
    method public logical GetDynamicABLSessionLimitInfo (output sessionInfo as longchar):
        // AdminManager.java: getDynamicABLSessionLimitInfo
        // biopasa.c: OTM_PASAGENTINFO_GETDYNAMICABLSESSIONLIMITINFO_ID -> csMtGetDynamicABLSessionLimitInfo

        define variable mptr as memptr no-undo.
        define variable retVal as logical no-undo.

        this-object:logMessage("GetDynamicABLSessionLimitInfo").

        assign retVal = Progress.ApplicationServer.AgentInfo:GetDynamicABLSessionLimitInfo(mptr).

        copy-lob from mptr // JSON data is spec'ed as UTF-8
            to sessionInfo convert target codepage 'utf-8':u.

        return retVal.

        finally:
            set-size(mptr) = 0.
        end finally.
    end method.

    /* Returns the agent call stack for a given SessionID

       @param character SessionID for which to return a call stack
       @param longchar JSON representation of the stack information
       @return logical Success/Failure */
    method public logical getAgentSessionStack (input  sessid as character,
                                                output pStack as longchar):
        // AgentManager.java: getSessionStacks
        // biopasa.c: OTM_PASAGENTINFO_GETAGENTSESSIONSTACK_ID -> csMtPasGetAgentSessionStackByChar

        define variable mptr       as memptr  no-undo.
        define variable retVal     as logical no-undo.
        define variable sessid_int as integer no-undo.
        define variable use_int    as logical no-undo initial no.

        this-object:logMessage(substitute("getAgentSessionStack - SessionID[&1]":u, sessid)).

        if length(sessid) le 10 then do:
            sessid_int = integer(sessid) no-error.
            if not error-status:error then
               use_int = yes.
        end.

        if use_int then
           retVal = Progress.ApplicationServer.AgentInfo:GetAgentSessionStack(sessid_int, mptr).
        else
           retVal = Progress.ApplicationServer.AgentInfo:GetAgentSessionStack(sessid, mptr).

        copy-lob from mptr
                 // JSON data is spec'ed as UTF-8
                 to pStack convert target codepage 'utf-8':u.

        return retVal.

        finally:
            set-size(mptr) = 0.
        end finally.
    end method.

    /* Returns the agent call stack for a given Agent SessionID

       @param integer Agent SessionID for which to return a call stack
       @param longchar JSON representation of the stack information
       @return logical Success/Failure */
    method public logical getAgentSessionStack (input  sessid as integer,
                                                output pStack as longchar):
        // AgentManager.java: getSessionStacks
        // biopasa.c: OTM_PASAGENTINFO_GETAGENTSESSIONSTACK_BYINT_ID -> csMtPasGetAgentSessionStack

        define variable mptr   as memptr  no-undo.
        define variable retVal as logical no-undo.

        this-object:logMessage(substitute("getAgentSessionStack - SessionID[&1]":u, sessid)).

        assign retVal = Progress.ApplicationServer.AgentInfo:GetAgentSessionStack(sessid, mptr).

        copy-lob from mptr
                 // JSON data is spec'ed as UTF-8
                 to pStack convert target codepage 'utf-8':u.

        return retVal.

        finally:
            set-size(mptr) = 0.
        end finally.
    end method.

    /* Returns a Client SessionID given an Agent SessionID

       @param integer SessionID
       @param character Client SessionID
       @return logical Success/Failure */
    method public logical getClientSessionID (input  agentSessId  as integer,
                                              output clientSessId as character):
        // biopasa.c: OTM_PASAGENTINFO_GETCLIENTSESSIONID_ID -> csMtPasGetClientSessionId

        this-object:logMessage(substitute("getClientSessionID - AgentSessID[&1]":u, agentSessId)).

        return Progress.ApplicationServer.AgentInfo:GetClientSessionID(input  agentSessId,
                                                                       output clientSessId).
    end method.

    /* Returns an Agent SessionID given a Client SessionID

       @param character Client SessionID 
       @return integer Agent SessionID */
    method public integer getAgentSessionID (input clsessid as character):
        // biopasa.c: OTM_PASAGENTINFO_GETAGENTSESSIONID_ID -> csMtPasGetAgentSessionId

        return Progress.ApplicationServer.AgentInfo:GetAgentSessionID(clsessid).
    end method.

    /* Returns the number of active agent requests

       @return int64 Number of (active) agent requests. Returns -1 if not enabled */
    method public int64 getAgentRequestQty ( ):
        // AgentManager.java: getActiveRequests
        // biopasa.c: OTM_PASAGENTINFO_GETREQUESTTABLE_ID -> bioPASAgentCreateTables

        define variable pasThandle as handle no-undo.
        define variable hBuffer    as handle no-undo.
        define variable hQuery     as handle no-undo.
        define variable qty        as int64  no-undo.

        this-object:logMessage("getAgentRequestQty").

        Progress.ApplicationServer.AgentInfo:getAgentRequestTableHandle(output pasThandle).
        if not valid-object(pasThandle) then return -1.

        hBuffer = pasThandle:default-buffer-handle.
        create query hQuery.
        hQuery:add-buffer(hBuffer).
        hQuery:query-prepare(substitute("preselect each &1 no-lock":u, hBuffer:name)).
        hQuery:query-open().
        qty = hQuery:num-results.

        return qty.

        finally:
            if valid-object(hQuery) then
            do:
                if hQuery:is-open then
                    hQuery:query-close.
                delete object hQuery no-error.
            end.
        end finally.
    end method.

    /* Returns the active request(s) for a given SessionID

       @param character SessionID
       @param table-handle Request info for the given SessionID */
    method public void getAgentActiveRequestData (input  sessionId as character,
                                                  output table-handle hTTCopy):
        // AgentManager.java: getMetrics[ACTIVE_REQUESTS]
        // biopasa.c: OTM_PASAGENTINFO_GETREQUESTTABLE_ID -> bioPASAgentCreateTables

        define variable hTTSrcBuffer  as handle no-undo.
        define variable hTTCopyBuffer as handle no-undo.
        define variable hQuery        as handle no-undo.
        define variable pasThandle    as handle no-undo.

        this-object:logMessage(substitute("getAgentActiveRequestData - SessionID[&1]":u, sessionId)).

        Progress.ApplicationServer.AgentInfo:getAgentRequestTableHandle(output pasThandle).
        if not valid-object(pasThandle) then return.

        /* create dynamic temp-table */
        create temp-table hTTCopy.

        /* Copy the schema from the one passed in */
        hTTCopy:create-like(pasThandle).

        /* Get it ready and name it - in this case, AgentRequest is the new temp-table name */
        hTTCopy:temp-table-prepare("AgentActiveRequest").

        /* Get the default buffer for both source and target tables */
        assign
            hTTSrcBuffer  = pasThandle:default-buffer-handle
            hTTCopyBuffer = hTTCopy:default-buffer-handle
            .

        /* First create query to fetch records from source table */
        create query hQuery.
        hQuery:set-buffers(hTTSrcBuffer).
        hQuery:query-prepare(substitute("for each &1":u, pasThandle:name)).
        hQuery:query-open().

        QUERYBLK:
        repeat:
            hQuery:get-next().
            if hQuery:query-off-end then leave QUERYBLK.

            if hTTSrcBuffer:buffer-field("_Request-BrokerSessionId"):buffer-value eq sessionId then
            do:
                /* Create record and copy from source */
                hTTCopyBuffer:buffer-create().
                hTTCopyBuffer:buffer-copy(hTTSrcBuffer).
                hTTCopyBuffer:buffer-release().
            end.
        end.

        /* Done with query */
        finally:
            if valid-object(hQuery) then
            do:
                if hQuery:is-open then
                    hQuery:query-close.
                delete object hQuery no-error.
            end.

            delete object hTTCopy.
        end finally.
    end method.

end class.
