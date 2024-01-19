/**************************************************************************
Copyright (c) 2022-2023 by Progress Software Corporation. All rights reserved.
**************************************************************************/
/*------------------------------------------------------------------------
    File        : OEManagerConnection
    Purpose     : Create a reusable connection for OEManager RESTful API's
    Description : See https://docs.progress.com/bundle/pas-for-openedge-reference/page/REST-API-Reference-for-oemanager.war.html
    Author(s)   : Dustin Grau
    Created     : Wed Oct 26 09:27:39 EDT 2022
    Notes       : Each instance of this class shall include and retain the
                  relevant server information (host, port, credentials, etc.)
                  required for accessing only one specific PAS instance.
                  For instructions on securing the OEManager endpoint, see:
                  https://docs.progress.com/bundle/openedge-security-and-auditing/page/Secure-the-Tomcat-Manager-and-OpenEdge-Manager-web-applications.html
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.LoggerFilterRegistry.
using OpenEdge.Logging.TokenResolver.
using OpenEdge.Logging.VoidLogger.
using OpenEdge.Logging.Writer.NamedFileWriter.
using OpenEdge.ApplicationServer.Util.OEManagerConnection.
using OpenEdge.ApplicationServer.Util.OEManagerEndpoint.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.ApplicationServer.Util.OEManagerConnection implements ISupportLogging:

    /**
     * This must remain compatible with OpenEdge 11.7.x, so use of the "var"
     * declaration or new constructs such as List<> should be avoided.
     */

    /* Store the URL components for the PAS instance to be managed. */
    define private variable cScheme   as character no-undo.
    define private variable cHost     as character no-undo.
    define private variable iPort     as integer   no-undo.
    define private variable cUserId   as character no-undo.
    define private variable cPassword as character no-undo.

    /* Components for the HttpClient instance w/ credentials. */
    define private variable oClient as IHttpClient no-undo.
    define private variable oCreds  as Credentials no-undo.

    /* Common, standard values for requests. */
    define private variable cContentType as character no-undo initial "application/vnd.progress+json".

    define public property Logger as ILogWriter no-undo
        get():
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(get-class(OpenEdge.ApplicationServer.Util.OEManagerConnection)).

            /**
             * A logger is always returned via GetLogger(), but if no configuration file exists it will be a VoidLogger instance.
             * Therefore, we should at least create a logger instance that can handle any message output in a consistent manner.
             * If the end-user wishes to alter this behavior then they can create a logging.config file for better control.
             */
            if type-of(this-object:Logger, VoidLogger) then
                assign this-object:Logger = LoggerBuilder:Build("OpenEdge.ApplicationServer.Util.OEManagerConnection")
                                                         :LogAt(LogLevelEnum:INFO) // Log every little thing.
                                                         :AddFilter(LoggerFilterRegistry:FULL_TEXT_FORMAT)
                                                         :AddFilter(new NamedFileWriter(session:temp-directory + "oemanager.log", true))
                                                         :Logger.

            return this-object:Logger.
        end get.
        set.

    /* Create the basic URL to a unique PAS instance (scheme, host, port). */
    define public property Instance as character no-undo initial ?
        get():
            if (this-object:Instance eq ?) then
                assign this-object:Instance = substitute("&1://&2:&3", cScheme, cHost, iPort).

            return this-object:Instance.
        end get.
        private set.

    /* Creates a connection using a valid URI

       @param URI Server Uri with credentials for Basic Auth */
    constructor private OEManagerConnection ( input poURI as URI ):
        assign
            cScheme   = poURI:Scheme
            cHost     = poURI:Host
            iPort     = poURI:Port
            cUserId   = poURI:User
            cPassword = poURI:Password
            .

        Assert:NotNullOrEmpty(cScheme).
        Assert:NotNullOrEmpty(cHost).
        Assert:IsPositive(iPort).
        Assert:NotNullOrEmpty(cUserId).
        Assert:NotNullOrEmpty(cPassword).

        this-object:CreateClient().
    end constructor.

    /* Creates a connection using a valid URI

       @param character Scheme
       @param character Host
       @param integer Port
       @param character Username for Basic Auth
       @param character Password for Basic Auth */
    constructor private OEManagerConnection ( input pcScheme as character,
                                              input pcHost   as character,
                                              input piPort   as integer,
                                              input pcUser   as character,
                                              input pcPasswd as character ):
        assign
            cScheme   = pcScheme
            cHost     = pcHost
            iPort     = piPort
            cUserId   = pcUser
            cPassword = pcPasswd
            .

        Assert:NotNullOrEmpty(cScheme).
        Assert:NotNullOrEmpty(cHost).
        Assert:IsPositive(iPort).
        Assert:NotNullOrEmpty(cUserId).
        Assert:NotNullOrEmpty(cPassword).

        this-object:CreateClient().
    end constructor.

    /* Create the HttpClient and Credentials objects for this connection. */
    method private void CreateClient ( ):
        assign oClient = ClientBuilder:Build():Client.
        assign oCreds = new Credentials("PASOE Manager Application", cUserId, cPassword).
    end method.

    /* Creates a client connection using a valid URI

       @param URI Server Uri with credentials for Basic Auth
       @return OEManagerConnection */
    method public static OEManagerConnection Build ( input poURI as URI ):
        return new OEManagerConnection(poURI).
    end method. /* Build */

    /* Creates a client connection using a valid URI

       @param character Scheme
       @param character Host
       @param integer Port
       @param character Username for Basic Auth
       @param character Password for Basic Auth
       @return OEManagerConnection */
    method public static OEManagerConnection Build ( input pcScheme as character,
                                                     input pcHost   as character,
                                                     input piPort   as integer,
                                                     input pcUser   as character,
                                                     input pcPasswd as character ):
        return new OEManagerConnection(pcScheme, pcHost, piPort, pcUser, pcPasswd).
    end method. /* Build */

    /** Helper methods for OEManager requests **/

    /* Perform a request to the PAS instance; expects an HTTP verb and valid URL
       where all parameters must be passed in (excluding the server instance).
       This handles various error conditions which may occur when attempting
       to reach the server or obtain the expected status or JSON results.

       @param MethodEnum HTTP Method (Verb)
       @param character RESTful API endpoint URL
       @return JsonObject Data returned from server */
    method protected JsonObject MakeRequest ( input poVerb    as MethodEnum,
                                              input pcHttpUrl as character ):
        define variable oReq  as IHttpRequest  no-undo.
        define variable oResp as IHttpResponse no-undo.
        define variable cURL  as character     no-undo.

        if not valid-object(oClient) then
            undo, throw new Progress.Lang.AppError("No HTTP client available", 0).

        if not valid-object(oCreds) then
            undo, throw new Progress.Lang.AppError("No HTTP credentials provided", 0).

        if (pcHttpUrl gt "") ne true then
            undo, throw new Progress.Lang.AppError("No URL provided", 0).

        do on error undo, throw
           on stop undo, retry:
            if retry then
                undo, throw new Progress.Lang.AppError("Encountered a stop condition", 0).

            assign cURL = this-object:Instance + "/" + pcHttpUrl.
            this-object:Logger:Debug(substitute("Calling URL: &1 &2", poVerb:ToString(), cURL)).

            /* Always log the OEM-API command URL with an exact time of execution. */
            this-object:LogCommand(poVerb:ToString(), cURL).

            case poVerb:
                when MethodEnum:GET then
                    oReq = RequestBuilder:Get(cURL)
                                         :AcceptContentType(cContentType)
                                         :UsingBasicAuthentication(oCreds)
                                         :Request.
                when MethodEnum:POST then
                    oReq = RequestBuilder:Post(cURL)
                                         :AcceptContentType(cContentType)
                                         :ContentType(cContentType)
                                         :UsingBasicAuthentication(oCreds)
                                         :Request.
                when MethodEnum:DELETE then
                    oReq = RequestBuilder:Delete(cURL)
                                         :AcceptContentType(cContentType)
                                         :ContentType(cContentType)
                                         :UsingBasicAuthentication(oCreds)
                                         :Request.
                otherwise
                    /**
                     * Note that the PUT method is not included as this is primarily used to alter runtime settings.
                     * This library is meant to only retrieve info/metrics and trigger non-permanent actions. Any
                     * HTTP verb not included above should then result in an error for the requested operation.
                     */
                    undo, throw new Progress.Lang.AppError(substitute("Unsupported HTTP method '&1' provided", poVerb:ToString()), 0).
            end case.

            if valid-object(oReq) then
                oResp = oClient:Execute(oReq).
            else
                undo, throw new Progress.Lang.AppError("Unable to create request object", 0).
        end.

        if valid-object(oResp) and oResp:StatusCode eq 200 then do:
            if valid-object(oResp:Entity) and type-of(oResp:Entity, JsonObject) then
                /* If we have an HTTP-200 status and a JSON object as the response payload, return the entity as-is. */
                return cast(oResp:Entity, JsonObject).
            else if valid-object(oResp:Entity) and type-of(oResp:Entity, OpenEdge.Core.String) then do:
                /* If we have an HTTP-200 status and a String as the response payload, return it within a "result" property. */
                define variable oStringResp as JsonObject no-undo.
                assign oStringResp = new JsonObject().
                oStringResp:Add("result", cast(oResp:Entity, OpenEdge.Core.String):Value).
                return oStringResp.
            end.
            else if valid-object(oResp:Entity) then do:
                /* Anything other than a JSON or String payload should be treated as a possible error condition. */
                undo, throw new Progress.Lang.AppError(substitute("Successful but non-JSON/String response object returned: &1",
                                                                  oResp:Entity:GetClass():TypeName), 0).
            end.
            else
                /* Anything other than a JSON payload should be treated as an error condition. */
                undo, throw new Progress.Lang.AppError("Successful but non-JSON response object returned", 0).
        end. /* Valid Entity */
        else do:
            /* Check the resulting response and response entity if valid. */
            if valid-object(oResp) and valid-object(oResp:Entity) then
                case true:
                    when type-of(oResp:Entity, OpenEdge.Core.Memptr) then
                        undo, throw new Progress.Lang.AppError(substitute("Response is a memptr of size &1",
                                                                          string(cast(oResp:Entity, OpenEdge.Core.Memptr):Size)), 0).

                    when type-of(oResp:Entity, OpenEdge.Core.String) then
                        undo, throw new Progress.Lang.AppError(string(cast(oResp:Entity, OpenEdge.Core.String):Value), 0).

                    when type-of(oResp:Entity, JsonObject) then
                        {&_proparse_ prolint-nowarn(overflow)}
                        undo, throw new Progress.Lang.AppError(string(cast(oResp:Entity, JsonObject):GetJsonText()), 0).

                    otherwise
                        undo, throw new Progress.Lang.AppError(substitute("Unknown type of response object: &1 [HTTP-&2]",
                                                                          oResp:Entity:GetClass():TypeName, oResp:StatusCode), 0).
                end case.
            else if valid-object(oResp) then
                /* Response is available, but entity is not. Just report the HTTP status code. */
                undo, throw new Progress.Lang.AppError(substitute("Unsuccessful status from server: HTTP-&1", oResp:StatusCode), 0).
            else
                /* Response is not even available (valid) so report that as an explicit case. */
                undo, throw new Progress.Lang.AppError("Invalid response from server, ", 0).
        end. /* failure */

        catch err as Progress.Lang.Error:
            /* Always report any errors during the API requests, and return an empty JSON object allowing remaining logic to continue. */
            this-object:Logger:Error(substitute("Error executing remote request: &1 [URL: &2]", err:GetMessage(1), cURL)).
            return new JsonObject().
        end catch.
        finally:
            delete object oReq no-error.
            delete object oResp no-error.
        end finally.
    end method. /* MakeRequest */

    /* Perform a request for information from the PAS instance; a valid URL
       with all parameters must be passed in (excluding the server instance)

       @param character RESTful API endpoint URL
       @return JsonObject Data returned from server */
    method public JsonObject GetData ( input pcHttpUrl as character ):
        return this-object:MakeRequest(MethodEnum:GET, pcHttpUrl).
    end method.

    /* Perform an update action against the PAS instance; a valid URL
       with all parameters must be passed in (excluding the server instance)

       @param character RESTful API endpoint URL
       @return JsonObject Data returned from server */
    method public JsonObject PostData ( input pcHttpUrl as character ):
        return this-object:MakeRequest(MethodEnum:POST, pcHttpUrl).
    end method. /* PostData */

    /* Perform a termination action against the PAS instance; a valid URL
       with all parameters must be passed in (excluding the server instance)

       @param character RESTful API endpoint URL
       @return JsonObject Data returned from server */
    method public JsonObject DeleteData ( input pcHttpUrl as character ):
        return this-object:MakeRequest(MethodEnum:DELETE, pcHttpUrl).
    end method. /* DeleteData */

    /* Return the operation outcome from a standard JSON response

       @param JsonObject Server's JSON response
       @return character Status as text */
    method public character GetOpOutcome ( input poResponse as JsonObject ):
        if not valid-object(poResponse) then return "".

        if JsonPropertyHelper:HasTypedProperty(poResponse, "operation", JsonDataType:String) and
           JsonPropertyHelper:HasTypedProperty(poResponse, "outcome", JsonDataType:String) then
            return substitute("~t&1: &2", poResponse:GetCharacter("operation"), poResponse:GetCharacter("outcome")).
        else
            return "".
    end method. /* GetOpOutcome */

    /* Write a server command (Verb+URL) to the configured log file

       @param character Action or HTTP Verb
       @param character Command bound for the OEManager webapp */
    method public void LogCommand ( input pcVerb as character, input pcCommand as character ):
        /* Output to the standard log file any commands executed via a connection. */
        this-object:Logger:Info(substitute("&1 &2", pcVerb, pcCommand)).
    end method. /* LogCommand */

    /** Specific methods for OEManager requests **/

    /* Get a listing of ABL Applications for a PAS instance
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/List-ABL-application-information.html

       @return JsonArray Array of ABL Application information */
    method public JsonArray GetApplications ( ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(OEManagerEndpoint:Applications).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then do:
            if JsonPropertyHelper:HasTypedProperty(oJsonResp:GetJsonObject("result"), "Application", JsonDataType:Array) then
                return oJsonResp:GetJsonObject("result"):GetJsonArray("Application").
            else
                return new JsonArray().
        end. /* result */
        else
            return new JsonArray().
    end method. /* GetApplications */

    /* Add (start) a new MSAgent for an ABL Application
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/Add-a-multi-session-agent.html

       @param character ABL Application Name
       @return character Returned status as text */
    method public character AddAgent ( input pcAblApp as character ):
        define variable oJsonResp as JsonObject no-undo.
        define variable oAgent    as JsonObject no-undo.
        define variable cOutMsg   as character  no-undo.

        assign oJsonResp = this-object:PostData(substitute(OEManagerEndpoint:AddAgent, pcAblApp)).
        if valid-object(oJsonResp) and JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then do:
            oAgent = oJsonResp:GetJsonObject("result").

            /* Add some additional information about the new MSAgent started. */
            if JsonPropertyHelper:HasTypedProperty(oAgent, "pid", JsonDataType:String) then
                assign cOutMsg = substitute("Started new PID: &1", oAgent:GetCharacter("pid")) + "~n".

            /* Obtain the standard status result from this request. */
            assign cOutMsg = cOutMsg + this-object:GetOpOutcome(oJsonResp).
        end. /* result */

        finally:
            {&_proparse_ prolint-nowarn(returnfinally)}
            return cOutMsg. // Always return available content.
        end finally.
    end method. /* AddAgent */

    /* Get a listing of available MSAgents for an ABL Application
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/List-agents.html

       @param character ABL Application Name
       @return JsonArray Array of MSAgent information */
    method public JsonArray GetAgents ( input pcAblApp as character ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(substitute(OEManagerEndpoint:Agents, pcAblApp)).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then do:
            if JsonPropertyHelper:HasTypedProperty(oJsonResp:GetJsonObject("result"), "agents", JsonDataType:Array) then
                return oJsonResp:GetJsonObject("result"):GetJsonArray("agents").
            else
                return new JsonArray().
        end. /* result */
        else
            return new JsonArray().
    end method. /* GetAgents */

    /* Get a listing of available MSAgents for an ABL Application, along with their
       session metrics and special agent metrics (available to OpenEdge 12.8+ instances)

       @param character ABL Application Name
       @return JsonArray Array of MSAgent/Session information */
    method public JsonArray GetAgentSessCombined ( input pcAblApp as character ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(substitute(OEManagerEndpoint:AgentSessCombined, pcAblApp)).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then do:
            if JsonPropertyHelper:HasTypedProperty(oJsonResp:GetJsonObject("result"), "agents", JsonDataType:Array) then
                return oJsonResp:GetJsonObject("result"):GetJsonArray("agents").
            else
                return new JsonArray().
        end. /* result */
        else
            return new JsonArray().
    end method. /* GetAgentSessCombined */

    /* Get all the agent manager properties for an ABL Application
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/Get-agent-configuration-properties.html

       @param character ABL Application Name
       @return JsonObject Object with AgentManager properties */
    method public JsonObject GetAgentManagerProperties ( input pcAblApp as character ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(substitute(OEManagerEndpoint:AgentManagerProperties, pcAblApp)).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then
            return oJsonResp:GetJsonObject("result").
        else
            return new JsonObject().
    end method. /* GetAgentManagerProperties */

    /* Get available agent metrics for an ABL Application

       @param character ABL Application Name
       @param integer Agent Process ID (PID)
       @return JsonArray Object with agent metrics */
    method public JsonArray GetAgentMetrics ( input pcAblApp as character,
                                              input piPID    as integer ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(substitute(OEManagerEndpoint:AgentMetrics, pcAblApp, piPID)).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then do:
            if JsonPropertyHelper:HasTypedProperty(oJsonResp:GetJsonObject("result"), "AgentStatHist", JsonDataType:Array) then
                return oJsonResp:GetJsonObject("result"):GetJsonArray("AgentStatHist").
            else
                return new JsonArray().
        end. /* result */
        else
            return new JsonArray().
    end method. /* GetAgentMetrics */

    /* Get a listng of agent (ABL) sessions for a single agent of an ABL Application
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/Get-session-metrics.html

       @param character ABL Application Name
       @param integer Agent Process ID (PID)
       @return JsonArray Array of ABL Sessions */
    method public JsonArray GetAgentSessions ( input pcAblApp as character,
                                               input piPID    as integer ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(substitute(OEManagerEndpoint:AgentSessions, pcAblApp, piPID)).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then do:
            if JsonPropertyHelper:HasTypedProperty(oJsonResp:GetJsonObject("result"), "AgentSession", JsonDataType:Array) then
                return oJsonResp:GetJsonObject("result"):GetJsonArray("AgentSession").
            else
                return new JsonArray().
        end. /* result */
        else
            return new JsonArray().
    end method. /* GetAgentSessions */

    /* Get the runtime stack information about a session of an MSAgent for an ABL Application
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/Dump-a-session-stack.html

       @param character ABL Application Name
       @param integer Agent Process ID (PID)
       @param integer ABL Session ID (numeric)
       @return JsonArray Array of MSAgent information */
    method public JsonArray GetAgentSessionStacks ( input pcAblApp  as character,
                                                    input piPID     as integer,
                                                    input piSession as integer ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(substitute(OEManagerEndpoint:AgentSessionStacks, pcAblApp, piPID, piSession)).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then do:
            if JsonPropertyHelper:HasTypedProperty(oJsonResp:GetJsonObject("result"), "ABLStacks", JsonDataType:Array) then
                return oJsonResp:GetJsonObject("result"):GetJsonArray("ABLStacks").
            else
                return new JsonArray().
        end. /* result */
        else
            return new JsonArray().
    end method. /* GetAgentSessionStacks */

    /* Get the runtime stack information about a session of an MSAgent for an ABL Application
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/Dump-a-session-stack.html

       @param character ABL Application Name
       @param integer Agent Process ID (PID)
       @param character Client Session ID (alphanumeric)
       @return JsonArray Array of MSAgent information */
    method public JsonArray GetAgentSessionStacks ( input pcAblApp  as character,
                                                    input piPID     as integer,
                                                    input pcSession as character ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(substitute(OEManagerEndpoint:AgentSessionStacks, pcAblApp, piPID, pcSession)).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then do:
            if JsonPropertyHelper:HasTypedProperty(oJsonResp:GetJsonObject("result"), "ABLStacks", JsonDataType:Array) then
                return oJsonResp:GetJsonObject("result"):GetJsonArray("ABLStacks").
            else
                return new JsonArray().
        end. /* result */
        else
            return new JsonArray().
    end method. /* GetAgentSessionStacks */

    /* Get the runtime stack information about an MSAgent for an ABL Application

       @param character ABL Application Name
       @param integer Agent Process ID (PID)
       @return JsonArray Array of MSAgent information */
    method public JsonArray GetAgentStacks ( input pcAblApp as character,
                                             input piPID    as integer ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(substitute(OEManagerEndpoint:AgentStacks, pcAblApp, piPID)).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then do:
            if JsonPropertyHelper:HasTypedProperty(oJsonResp:GetJsonObject("result"), "ABLStacks", JsonDataType:Array) then
                return oJsonResp:GetJsonObject("result"):GetJsonArray("ABLStacks").
            else
                return new JsonArray().
        end. /* result */
        else
            return new JsonArray().
    end method. /* GetAgentStacks */

    /* Get a listing of agent (ABL) threads for an ABL Application;
       Useful for calculating the lifetime of an ABLSession from its start time

       @param character ABL Application Name
       @param integer Agent Process ID (PID)
       @return JsonArray Array of MSAgent threads */
    method public JsonArray GetAgentThreads ( input pcAblApp as character,
                                              input piPID    as integer ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(substitute(OEManagerEndpoint:AgentThreads, pcAblApp, piPID)).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then do:
            if JsonPropertyHelper:HasTypedProperty(oJsonResp:GetJsonObject("result"), "AgentThread", JsonDataType:Array) then
                return oJsonResp:GetJsonObject("result"):GetJsonArray("AgentThread").
            else
                return new JsonArray().
        end. /* result */
        else
            return new JsonArray().
    end method. /* GetAgentThreads */

    /* Get a listing of client (HTTP) sessions for an ABL Application
       https://docs.progress.com/bundle/pas-for-openedge-reference/page/Get-session-information.html
       https://docs.progress.com/bundle/pas-for-openedge-management/page/About-session-and-request-states.html

       @param character ABL Application Name
       @return JsonArray Array of client sessions */
    method public JsonArray GetClientSessions ( input pcAblApp as character ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(substitute(OEManagerEndpoint:ClientSessions, pcAblApp)).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then do:
            if JsonPropertyHelper:HasTypedProperty(oJsonResp:GetJsonObject("result"), "OEABLSession", JsonDataType:Array) then
                return oJsonResp:GetJsonObject("result"):GetJsonArray("OEABLSession").
            else
                return new JsonArray().
        end. /* result */
        else
            return new JsonArray().
    end method. /* GetClientSessions */

    /* Get a listing of session info (incl. the dynamic session limit) for an ABL Application
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/Get-dynamic-session-limit.html

       @param character ABL Application Name
       @param integer Agent Process ID (PID)
       @return JsonArray Array of session information */
    method public JsonArray GetDynamicSessionLimit ( input pcAblApp as character,
                                                     input piPID as integer ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(substitute(OEManagerEndpoint:DynamicSessionLimit, pcAblApp, piPID)).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then do:
            if JsonPropertyHelper:HasTypedProperty(oJsonResp:GetJsonObject("result"), "AgentSessionInfo", JsonDataType:Array) then
                return oJsonResp:GetJsonObject("result"):GetJsonArray("AgentSessionInfo").
            else
                return new JsonArray().
        end. /* result */
        else
            return new JsonArray().
    end method. /* GetDynamicSessionLimit */

    /* Get all the session manager properties for an ABL Application
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/Get-configuration-properties.html

       @param character ABL Application Name
       @return JsonObject Object with SessionManager properties */
    method public JsonObject GetSessionManagerProperties ( input pcAblApp as character ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(substitute(OEManagerEndpoint:SessionManagerProperties, pcAblApp)).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then
            return oJsonResp:GetJsonObject("result").
        else
            return new JsonObject().
    end method. /* GetSessionManagerProperties */

    /* Get metrics about the session manager which comes from the collectMetrics flag
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/Get-runtime-metrics.html

       @param character ABL Application Name
       @return JsonObject Abject of session metrics */
    method public JsonObject GetSessionMetrics ( input pcAblApp as character ):
        define variable oJsonResp as JsonObject no-undo.

        assign oJsonResp = this-object:GetData(substitute(OEManagerEndpoint:SessionMetrics, pcAblApp)).
        if JsonPropertyHelper:HasTypedProperty(oJsonResp, "result", JsonDataType:Object) then
            return oJsonResp:GetJsonObject("result").
        else
            return new JsonObject().
    end method. /* GetSessionMetrics */

    /* Write any accumulated deferred log data of an MSAgent for an ABL Application to the configured output file
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/Flush-deferred-log-buffer-to-agent-log-file.html

       @param character ABL Application Name
       @param integer Agent Process ID (PID)
       @return JsonObject Object as server response */
    method public JsonObject FlushDeferredLog ( input pcAblApp as character,
                                                input piPID    as integer ):
        return this-object:GetData(substitute(OEManagerEndpoint:FlushDeferredLog, pcAblApp, piPID)).
    end method. /* FlushDeferredLog */

    /* Trigger a refresh (termination) of all sessions of an MSAgent for an ABL Application
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/Refresh-all-ABL-sessions-of-one-or-all-agents.html

       @param character ABL Application Name
       @param character Agent ID (alphanumeric)
       @return JsonObject Object as server response */
    method public JsonObject RefreshAgent ( input pcAblApp  as character,
                                            input pcAgentID as character ):
        return this-object:DeleteData(substitute(OEManagerEndpoint:AgentSessions, pcAblApp, pcAgentID)).
    end method. /* RefreshAgent */

    /* Clear (reset) any accumulated agent stat data of an MSAgent for an ABL Application

       @param character ABL Application Name
       @param integer Agent Process ID (PID)
       @return JsonObject Object as server response */
    method public JsonObject ResetAgentStats ( input pcAblApp as character,
                                               input piPID    as integer ):
        return this-object:DeleteData(substitute(OEManagerEndpoint:AgentStatData, pcAblApp, piPID)).
    end method. /* ResetAgentStats */

    /* Clear (reset) any accumulated deferred log data of an MSAgent for an ABL Application
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/Reset-deferred-log-buffer.html

       @param character ABL Application Name
       @param integer Agent Process ID (PID)
       @return JsonObject Object as server response */
    method public JsonObject ResetDeferredLog ( input pcAblApp as character,
                                                input piPID    as integer ):
        return this-object:DeleteData(substitute(OEManagerEndpoint:ResetDeferredLog, pcAblApp, piPID)).
    end method. /* ResetDeferredLog */

    /* Terminate an agent (ABL) session for an ABL Application

       @param character ABL Application Name
       @param integer Agent Process ID (PID)
       @param integer ABL Session ID (numeric)
       @param integer Termination option [0-2]
       @return JsonObject Object as server response */
    method public JsonObject TerminateAblSession ( input pcAblApp  as character,
                                                   input piPID     as integer,
                                                   input piSession as integer,
                                                   input piTermOpt as integer ):
        return this-object:DeleteData(substitute(OEManagerEndpoint:AgentSession, pcAblApp, piPID, piSession, piTermOpt)).
    end method. /* TerminateAblSession */

    /* Terminate a client (HTTP) session for an ABL Application
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/Terminate-a-session.html

       @param character ABL Application Name
       @param integer Termination option [0-2]
       @param character Client Session ID (alphanumeric)
       @return JsonObject Object as server response */
    method public JsonObject TerminateClientSession ( input pcAblApp  as character,
                                                      input piTermOpt as integer,
                                                      input pcSession as character ):
        define variable cHttpUrl as character no-undo.

        assign cHttpUrl = substitute(OEManagerEndpoint:ClientSession, pcAblApp, piTermOpt) + "&sessionID".
        assign cHttpUrl = substitute("&1=&2", cHttpUrl, pcSession).

        return this-object:DeleteData(cHttpUrl).
    end method. /* TerminateClientSession */

    /* Stop (terminate) a single MSAgent for an ABL Application
        https://docs.progress.com/bundle/pas-for-openedge-reference/page/Stop-a-multi-session-agent.html

       @param character ABL Application Name
       @param character Internal Agent ID (alphanumeric)
       @param character Time to wait (ms) for current request to finish
       @param character Time to wait (ms) after the current request
       @return JsonObject Object as server response */
    method public JsonObject StopAgent ( input pcAblApp     as character,
                                         input pcAgentID    as character,
                                         input piWaitFinish as character,
                                         input piWaitAfter  as character ):
        define variable cHttpUrl as character no-undo.

        /* For security reasons, we use the internal AgentID to identify the MSAgent to be stopped. */
        assign cHttpUrl = substitute(OEManagerEndpoint:AgentStop, pcAblApp, pcAgentID)
                        + "?waitToFinish=" + piWaitFinish + "&waitAfterStop=" + piWaitAfter.

        return this-object:DeleteData(cHttpUrl).
    end method. /* StopAgent */

end class.
