/**************************************************************************
Copyright (c)  2014,2021-2022 by Progress Software Corporation. All rights reserved.
**************************************************************************/
 /*------------------------------------------------------------------------
    File        : AgentManager.cls
    Description : Used by the Server Broker tools to manage agents/sessions.
    Author(s)   : aherbstr, dugrau
    Created     : Tuesday July 8 2014
    Notes       : Requests originate from Java MBeans which are utilized by the
                  OEJMX utility or oemanager WebApp via the following sources:
                    pasoe/com.progress.appserv.clientrt/
                        src/main/java/com/progress/appserv/clientrt/admin/
                            AdminConstants.java (CLASS_AGENTMGR)
                            SessionManager.java
                    pasoe/com.progress.appserv.manager/
                        src/main/java/com/progress/appserv/manager/admin/
                            AgentManager.java
                        src/main/java/com/progress/appserv/manager/jmx/
                            AgentManagerJmx.java
                            BrokerServiceManagerJmx.java
                        src/main/java/com/progress/appserv/manager/rest/
                            AgentManagerService.java
                            BrokerManagerService.java

                  The ABL code utilizes Progress.ApplicationServer.* classes written in C:
                    src/biosys/biopasainit.c (CLASS Progress.ApplicationServer.AgentManager)
                    src/biosys/biopasa.c (bioPASAgentManager)
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

class OpenEdge.ApplicationServer.AgentManager final:

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
             * Sample Log File: C:\OpenEdge\WRK\oepas1\temp\AgentManager-A5309.log
             *
             * To enable logging output set the logLevel to DEBUG or higher.
             * Sample JSON for logging.config file:
             *   {
             *       "logger": {
             *           "OpenEdge.ApplicationServer.AgentManager": {
             *               "logLevel": "DEBUG"
             *           }
             *       }
             *   }
             */
            define variable cLogType  as character     no-undo initial "OpenEdge.ApplicationServer.AgentManager".
            define variable cLogFile  as character     no-undo initial "$~{session.temp-dir}/AgentManager-A$~{req.agent}.log".
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
                assign oLogLevel = LogLevelEnum:Default. // aka. WARN

            // Manually create a logger instance using 2 filters:
            //  FullTextFormat  - Provides a common and expected log format with timestamp.
            //  NamedFileWriter - Writes to an agent-specific logfile in the session temp-dir.
            oFilters[1] = new FullTextFormat(). // Use a common log format with timestamp.
            oFilters[2] = new NamedFileWriter(TokenResolver:Resolve(cLogFile), true).
            this-object:Logger = new Logger(cLogType, oLogLevel, oFilters).

            {&_proparse_ prolint-nowarn(varusage)}
            catch uncaught as Progress.Lang.Error:
                // Swallow any logging errors, as we don't care and must not impede the admin request.\
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

    // Holds in instance of the internal PAS AgentManager object.
    define private variable pasam as class Progress.ApplicationServer.AgentManager no-undo.

    /* Constructor */
    constructor public AgentManager():
        this-object:logMessage(substitute("Creating AgentManager Instance [&1]":u, proversion(1))).

        pasam = new Progress.ApplicationServer.AgentManager().
    end constructor.

    /* Destructor */
    destructor AgentManager ( ):
        this-object:logMessage("Destroying AgentManager Instance").

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

    /* Cancels a request for a given SessionID and RequestID

       @param character SessionID
       @param character RequestID
       @param logical Success/Failure */
    method public logical cancelRequest (input brokerSessionId as character,
                                         input requestId       as character):
        // SessionManager.java: cancelRequest
        // biopasa.c: OTM_PASAGENTMANAGER_CANCELREQUEST_ID -> csMtPasFindAndCancelRequest

        this-object:logMessage(substitute("cancelRequest - BrokerID[&1] RequestID[&2]":u, brokerSessionId, requestId)).
        return pasam:cancelRequest(brokerSessionId, requestId).
    end method.

    /* Terminates a specified number of inactive ABL sessions

       @param integer Number of sessions to terminate (0=no limit, otherwise up to given number >0)
       @param integer Number of sessions terminated */
    method public integer terminateFreeABLSessions (input numSessions as integer):
        // SessionManager.java: terminateFreeSessions
        // biopasa.c: OTM_PASAGENTMANAGER_TERMINATEFREESESSIONS_ID -> csMtPasTerminateFreeSessions

        this-object:logMessage(substitute("terminateFreeABLSessions - NumSessions[&1]":u, numSessions)).
        return pasam:terminateFreeSessions(numSessions).
    end method.

    /* Terminates a specified Agent SessionID, if session is inactive

       @param integer Agent SessionID
       @param logical Success/Failure */
    method public logical terminateFreeABLSession (input agentSessionId as integer):
        // SessionManager.java: terminateFreeSession
        // biopasa.c: OTM_PASAGENTMANAGER_TERMINATEFREESESSION_ID -> csMtPasReapSession

        this-object:logMessage(substitute("terminateFreeABLSession - AgentSessID[&1]":u, agentSessionId)).
        return pasam:terminateFreeSession(agentSessionId).
    end method.

    /* Terminates a specified ABL session

       @param character Broker SessionID
       @param integer Termination option [0=Graceful, 1=Forced, 2=Finish & Stop]
       @param logical Success/Failure */
    method public logical terminateABLSession (input brokerSessionId as character,
                                               input terminateOption as integer):
        // SessionManager.java: terminateSession
        // biopasa.c: OTM_PASAGENTMANAGER_TERMINATESESSION_ID -> csMtPasFindAndTerminateSession

        this-object:logMessage(substitute("terminateABLSession - BrokerSessID[&1] TerminateOpt[&2]":u, brokerSessionId, terminateOption)).
        return pasam:terminateSession(brokerSessionId, terminateOption).
    end method.

    /* Terminates a specified ABL session

       @param character Agent SessionID
       @param integer Termination option [0=Graceful, 1=Forced, 2=Finish & Stop]
       @param logical Success/Failure */
    method public logical terminateABLSession (input agentSessionId  as integer,
                                               input terminateOption as integer):
        // SessionManager.java: terminateSession
        // biopasa.c: OTM_PASAGENTMANAGER_TERMINATESESSION_BYINT_ID -> csMtPasTerminateSession

        this-object:logMessage(substitute("terminateABLSession - AgentSessID[&1] TerminateOpt[&2]":u, agentSessionId, terminateOption)).
        return pasam:terminateSession(agentSessionId, terminateOption).
    end method.

    /* Terminates the current MSAS Agent using default timeouts

       @param logical Success/Failure */
    method public logical stopAgent ():
        // biopasa.c: OTM_PASAGENTMANAGER_STOPAGENT_ID -> csMtNotifyAgentShutdown

        this-object:logMessage("stopAgent").
        return pasam:stopAgent().
    end method.

    /* Terminates the current MSAS Agent with specified timeouts

       @param integer Time (in ms) to wait for current requests to finish
       @param integer Time (in ms) to wait after the stop is issued
       @param logical Success/Failure */
    method public logical stopAgent (input waitToFinish  as integer,
                                     input waitAfterStop as integer):
        // AgentManager.java: stopAgent
        // biopasa.c: OTM_PASAGENTMANAGER_STOPAGENT_NICE_ID -> csMtNotifyAgentShutdown

        this-object:logMessage(substitute("stopAgent - WaitToFinish[&1] WaitAfterStop[&2]":u, waitToFinish, waitAfterStop)).
        return pasam:stopAgent(waitToFinish, waitAfterStop).
    end method.

    /* Initiate the debugger for a connection

       @param character Connection string
       @param logical Success/Failure */
    method public logical InitiateDebugger (input connectstring as character):
        // AgentManager.java: initiateDebugger
        // biopasa.c: OTM_PASAGENTMANAGER_INITIATEDEBUGGER_ID -> csMtInitiateDebugger

        this-object:logMessage(substitute("InitiateDebugger - ConnectString[&1]":u, connectstring)).
        return pasam:InitiateDebugger(connectstring).
    end method.

    /* Access special debug features

       @param character Operation to execute
       @param character Modifiers to the operation
       @param integer Integer input parameters
       @param character Character input parameters
       @param integer Integer output parameters
       @param character Character output parameters
       @param logical Success/Failure */
    method public logical DebugTest (input  operation    as character,
                                     input  modifiers    as character,
                                     input  iparm        as integer,
                                     input  cparm        as character,
                                     output intoutparm   as integer,
                                     output lcharoutparm as longchar):
        // AgentManager.java: debugTest
        // biopasa.c: OTM_PASAGENTMANAGER_DEBUGTEST_ID -> csMtDebugTest

        this-object:logMessage(substitute("DebugTest - Operation[&1] Modifiers[&2] IParm[&3] CParm[&4]":u, operation, modifiers, iparm, cparm)).
        return pasam:DebugTest(operation, modifiers, iparm, cparm, output intoutparm, output lcharoutparm).
    end method.

    /* Update dynamic properties (eg. log entry types, logging level, etc.)

       @param character Dynamic properties string (as comma-delimited list)
       @param logical Success/Failure */
    method public logical dynamicPropertiesUpdate (input dynamicPropertiesString as character):
        // AgentManager.java: dynamicPropertiesUpdate
        // biopasa.c: OTM_PASAGENTMANAGER_DYNPROPSUPDATE_ID -> csMtDynamicPropertiesUpdate

        this-object:logMessage(substitute("dynamicPropertiesUpdate - DynamicPropString[&1]":u, dynamicPropertiesString)).
        return pasam:DynamicPropertiesUpdate(dynamicPropertiesString).
    end method.

    /* Toggle the tracking of ABLObjects by this agent

       @param logical Toggle [True=enable, False=disable]
       @param logical Success/Failure */
    method public logical TrackABLObjects (input toggle as logical):
        // AgentManager.java: trackABLObjects
        // biopasa.c: OTM_PASAGENTMANAGER_TRACKABLOBJECTS_ID -> csMtTrackABLObjects

        this-object:logMessage(substitute("TrackABLObjects - Toggle[&1]":u, toggle)).
        return pasam:TrackABLObjects(toggle).
    end method.

    /* Returns indication if agent is currently tracking ABLObjects

       @param logical Current tracking state [True=enabled, False=disabled] */
    method public logical TrackingABLObjects ():
        // AdminManager.java: trackingABLObjects
        // biopasa.c: OTM_PASAGENTMANAGER_TRACKINGABLOBJECTS_ID -> csMtTrackingABLObjs

        this-object:logMessage("TrackingABLObjects").
        return pasam:TrackingABLObjects().
    end method.

    /* Initiate the return of the ABLObjects report for all sessions of this agent

       @param longchar JSON data to be returned
       @param logical Success/Failure */
    method public logical GetABLObjectsReport (output jsonrpt as longchar):
        // AdminManager.java: getABLObjectsReport
        // biopasa.c: OTM_PASAGENTMANAGER_GETABLOBJECTSREPORT_ID -> csMtGetABLObjectsReportAll

        this-object:logMessage("GetABLObjectsReport").
        return pasam:GetABLObjectsReport(output jsonrpt).
    end method.

    /* Initiate the return of the ABLObjects report for a given Agent SessionID

       @param integer Agent SessionID
       @param longchar JSON data to be returned
       @param logical Success/Failure */
    method public logical GetABLObjectsReport (input  AgentSessId as integer,
                                               output jsonrpt     as longchar):
        // AdminManager.java: getABLObjectsReport
        // biopasa.c: OTM_PASAGENTMANAGER_GETABLOBJECTSREPORT_BYINT_ID -> csMtGetABLObjectsReport

        this-object:logMessage(substitute("GetABLObjectsReport - AgentSessID[&1]":u, AgentSessId)).
        return pasam:GetABLObjectsReport(AgentSessId, output jsonrpt).
    end method.

    /* Toggle the tracking of memory use by this agent

       @param logical Toggle [True=enable, False=disable]
       @param logical Success/Failure */
    method public logical TrackMemoryUse (input toggle as logical):
        // AdminManager.java: trackMemoryUse
        // biopasa.c: OTM_PASAGENTMANAGER_TRACKMEMORYUSE_ID -> csMtTrackMemUse

        this-object:logMessage(substitute("TrackMemoryUse - Toggle[&1]":u, toggle)).
        return pasam:TrackMemoryUse(toggle).
    end method.

    /* Returns indication if agent is currently tracking memory use

       @param logical Current tracking state [True=enabled, False=disabled] */
    method public logical TrackingMemoryUse ():
        // AdminManager.java: trackingMemoryUse
        // biopasa.c: OTM_PASAGENTMANAGER_TRACKINGMEMORYUSE_ID -> csMtTrackingMemUse

        this-object:logMessage("TrackingMemoryUse").
        return pasam:TrackingMemoryUse().
    end method.

    /* Initiate the return of the ABLObjects report for all sessions of this agent

       @param longchar JSON data to be returned
       @param logical Success/Failure */
    method public logical GetMemoryUseReport (output jsonrpt as longchar):
        // AdminManager.java: getMemoryUseReport
        // biopasa.c: OTM_PASAGENTMANAGER_GETMEMORYUSEREPORT_ID -> csMtMemuseReport

        this-object:logMessage("GetMemoryUseReport").
        return pasam:GetMemoryUseReport(output jsonrpt).
    end method.

    /* Initiate the return of the ABLObjects report for a given Agent SessionID

       @param integer Agent SessionID
       @param longchar JSON data to be returned
       @param logical Success/Failure */
    method public logical GetMemoryUseReport (input  AgentSessId as integer,
                                              output jsonrpt     as longchar):
        // AdminManager.java: getMemoryUseReport
        // biopasa.c: OTM_PASAGENTMANAGER_GETMEMORYUSEREPORT_BYINT_ID -> csMtMemuseReport

        this-object:logMessage(substitute("GetMemoryUseReport - AgentSessID[&1]":u, AgentSessId)).
        return pasam:GetMemoryUseReport(AgentSessId, output jsonrpt).
    end method.

    /* Trigger the pushing of profiler data for this agent

       @param character Destination URL for output
       @param integer Number of requests to push profiler data
       @param longchar Settings for profiler collection (as JSON)
       @param logical Success/Failure */
    method public logical PushProfilerData (input OutUrl       as character,
                                            input RequestCount as integer,
                                            input SettingsJson as longchar):
        // AdminManager.java: pushProfilerData
        // biopasa.c: OTM_PASAGENTMANAGER_PUSHPROF_ID -> csMtInitPushProfilerData

        define variable cUrl as longchar no-undo.
        assign cUrl = OutUrl. // A leading character parameter to substitute should be a longchar if subsequent parameters are longchar.

        define variable cMsg as longchar no-undo initial "PushProfilerData - OutUrl[&1] RequestCount[&2] Settings[&3":u.
        {&_proparse_ prolint-nowarn(overflow)}
        this-object:logMessage(string(substitute(cMsg, cUrl, RequestCount, SettingsJson))).
        return pasam:PushProfilerData(OutUrl, RequestCount, SettingsJson).
    end method.

    /* Return the current profiler settings in use

       @param longchar JSON data containing profiler settings
       @param logical Success/Failure */
    method public logical GetProfilerSettings (output profSettings as longchar):
        // AdminManager.java: getProfilerSettings
        // biopasa.c: OTM_PASAGENTMANAGER_GETPROF_ID -> csMtProfilerFilterSettings

        this-object:logMessage("GetProfilerSettings").
        return pasam:GetProfilerSettings(output profSettings).
    end method.

    /* Flush the current deferred log buffer (to log file on disk)

       @param logical Success/Failure */
    method public logical flushDeferredLog ():
        // AdminManager.java: flushDeferredLog
        // biopasa.c: OTM_PASAGENTMANAGER_FLUSHDEFERREDLOG_ID -> csMtFlushDeferredLog

        this-object:logMessage("flushDeferredLog").
        return pasam:flushDeferredLog().
    end method.

    /* Reset the deferred logging buffer

       @param logical Success/Failure */
    method public logical resetDeferredLog ():
        // AdminManager.java: resetDeferredLog
        // biopasa.c: OTM_PASAGENTMANAGER_RESETDEFERREDLOG_ID -> csMtResetDeferredLog

        this-object:logMessage("resetDeferredLog").
        return pasam:resetDeferredLog().
    end method.

    /* Reset the dynamic ABL Session limit

       @param longchar Current session information
       @param logical Success/Failure */
    method public logical ResetDynamicABLSessionLimit (output sessionInfo as longchar):
        // AdminManager.java: resetDynamicABLSessionLimit
        // biopasa.c: OTM_PASAGENTMANAGER_RESETDYNAMICABLSESSIONLIMIT_ID -> csMtResetDynamicABLSessionLimit

        this-object:logMessage("ResetDynamicABLSessionLimit").
        return pasam:ResetDynamicABLSessionLimit(output sessionInfo).
    end method.

    /* Set the dynamic ABL Session limit

       @param integer New limit value
       @param longchar Current session information
       @param logical Success/Failure */
    method public logical SetDynamicABLSessionLimit (input  limit       as integer,
                                                     output sessionInfo as longchar):
        // AdminManager.java: setDynamicABLSessionLimit
        // biopasa.c: OTM_PASAGENTMANAGER_SETDYNAMICABLSESSIONLIMIT_ID -> csMtSetDynamicABLSessionLimit

        this-object:logMessage(substitute("SetDynamicABLSessionLimit - Limit[&1]":u, limit)).
        return pasam:SetDynamicABLSessionLimit(limit, output sessionInfo).
    end method.

end class.
