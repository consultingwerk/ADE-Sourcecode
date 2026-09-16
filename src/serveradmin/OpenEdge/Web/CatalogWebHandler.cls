/**************************************************************************************************************************
Copyright (c) 2026 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
***************************************************************************************************************************/
/*------------------------------------------------------------------------
    File        : CatalogWebHandler
    Purpose     : Provide a standard endpoint for API catalog retrieval
    Description :
    Author(s)   : Dustin Grau
    Created     : Mon Feb 2 13:54:14 EDT 2026
    Notes       : By default provides an endpoint for OpenAPI v3.1
                  formatted catalog of available services from the
                  Service Registry used by the DataObjectHandler.

    ENVIRONMENT VARIABLE OVERRIDE:
    ------------------------------
    SERVICEMAP_PATHS - Optional override for service discovery paths

    Format: Semicolon-separated list of absolute directory paths
    Example: "C:/app/services;C:/common/maps;D:/shared/openedge"

    When set, completely bypasses automatic path discovery and uses
    only the specified paths to search for .gen/.map files.

    When not set, automatically discovers paths based on:
    - CATALINA_BASE/openedge (common location)
    - CATALINA_BASE/ablapps/{ablApp}/openedge
    - CATALINA_BASE/webapps/{webapp}/WEB-INF/openedge (WEB-enabled only)

    By default a catalogService.handlers file will be deployed as part of
    the .oeds package. However, if you with to manually utilize the class
    as a WebHandler add the following entry within openedge.properties
    for the appropriate ABL Application and WebApp:
      handler<n>=OpenEdge.Web.CatalogWebHandler : catalogService/openapi

    OEDS DEPLOYMENT AND USAGE:
    --------------------------

    >cd $CATALINA_BASE
    >bin/tcman deployablsvc -oeds {DLC}/servers/pasoe/extras/catalogWebService.oeds -webapp {webapp-name} -ablapp {ablapp-name}

    GET { http | https }://{host}:{port}/[{web_app}/]web/catalogService/openapi
------------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.SemanticVersion.
using OpenEdge.Core.StringConstant.
using OpenEdge.Logging.LogFilterBuilderRegistry.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Logging.LoggerFilterRegistry.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterRegistry.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterRegistry.
using OpenEdge.Web.IWebRequest.
using OpenEdge.Web.WebHandler.
using OpenEdge.Web.WebResponse.
using OpenEdge.Web.WebResponseWriter.
using OpenEdge.Web.DataObject.ServiceRegistry.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterRegistry.
using OpenEdge.Web.DataObject.Writer.IOpenAPIServiceWriter.
using OpenEdge.Web.DataObject.Writer.OpenAPI31ServiceWriter.
using OpenEdge.Web.DataObject.Writer.OperationHandlerRegistry.
using OpenEdge.Web.DataObject.Writer.ResponseElementWriterRegistry.
using OpenEdge.Web.SendExceptionError.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonDataType.

class OpenEdge.Web.CatalogWebHandler
    inherits WebHandler
    use-widget-pool
:

    /* Return the $CATALINA_BASE OS environment variable if set */
    define public property CatalinaBase as character init ? no-undo
        get():
            if CatalinaBase eq ? then
            do:
                CatalinaBase = this-object:getFullPathname(os-getenv('CATALINA_BASE':u)).
                if CatalinaBase eq ? then
                    CatalinaBase = ''.
            end.
            return CatalinaBase.
        end get.
        private set.

    /* Tracks the last time the CB props file was loaded from the file system. */
    define protected variable dCBPropsLastLoaded as datetime no-undo initial ?.

    /* Tracks the last time the OE props file was loaded from the file system. */
    define protected variable dOEPropsLastLoaded as datetime no-undo initial ?.

    /* Find a better default port in use with this instance. */
    define protected variable iPort as integer no-undo.

    /* JSON structure mapping ABL apps to webapps with enabled status.
     * Format: { "ablAppName": { "webapps": { "webappName": true/false } } }
     */
    define protected variable oAppWebappConfig as JsonObject no-undo.

    /* Version for the application document. */
    define private variable oApiVersion as SemanticVersion no-undo.

    /* Path separator for service map paths (semicolon for cross-platform compatibility). */
    define private variable cPathSeparator as character no-undo init ';'.

    constructor public CatalogWebHandler ( ):
        super().

        // Override the logger with one for this class.
        assign this-object:Logger = LoggerBuilder:GetLogger(get-class(OpenEdge.Web.CatalogWebHandler)).

        // Define the API version for this application.
        assign oApiVersion = new SemanticVersion(1, 0, 0).

        this-object:Discovery(). // Perform local discovery of server info.
    end constructor.

    /**
     * Get the current webapp name from the web request context.
     * Extracts the webapp from the CONTEXT_PATH CGI variable.
     * Returns the webapp name (e.g., 'ROOT', 'demo', 'api').
     */
    method protected character GetCurrentWebApp ( ):
        define variable cContextPath as character no-undo.
        define variable cWebApp      as character no-undo.

        /* Get the context path from the web request.
         * Format: "" (empty for ROOT), "/demo", "/api", etc.
         */
        assign cContextPath = web-context:get-cgi-value('env':u, 'CONTEXT_PATH':u).

        if (cContextPath gt '') eq true then do:
            /* Remove leading slash and extract webapp name. */
            assign cWebApp = trim(cContextPath, '/':u).
        end.
        else
            /* Empty context path means ROOT webapp. */
            assign cWebApp = 'ROOT':u.

        this-object:Logger:Debug(substitute('Current WebApp from context path: &1':u, cWebApp)).

        return cWebApp.

        catch err as Progress.Lang.Error:
            this-object:Logger:Error(substitute('Error in GetCurrentWebApp: &1':u, err:GetMessage(1))).
            return ''.
        end catch.
    end method. // GetCurrentWebApp

    /**
     * Find the ABL application name for a given webapp.
     * Looks up the webapp in the oAppWebappConfig JSON structure.
     * Returns the ABL app name that owns this webapp, or empty string if not found.
     * Note: Returns the ABL app regardless of whether the webapp is enabled.
     */
    method protected character GetAblAppForWebApp ( input pcWebApp as character ):
        define variable cAblApp     as character  no-undo.
        define variable cAppNames   as character  no-undo extent.
        define variable iApp        as integer    no-undo.
        define variable oAppConfig  as JsonObject no-undo.
        define variable oWebapps    as JsonObject no-undo.

        if not valid-object(oAppWebappConfig) then
            return ''.

        /* Iterate through all ABL app names in the config. */
        assign cAppNames = oAppWebappConfig:GetNames().
        do iApp = 1 to extent(cAppNames):
            assign cAblApp = cAppNames[iApp].

            if oAppWebappConfig:Has(cAblApp) and
               oAppWebappConfig:GetType(cAblApp) eq JsonDataType:Object then do:
                assign oAppConfig = oAppWebappConfig:GetJsonObject(cAblApp).

                /* Check if this app has a webapps object. */
                if oAppConfig:Has('webapps':u) and
                   oAppConfig:GetType('webapps':u) eq JsonDataType:Object then do:
                    assign oWebapps = oAppConfig:GetJsonObject('webapps':u).

                    /* Check if this webapp belongs to this ABL app. */
                    if oWebapps:Has(pcWebApp) then do:
                        this-object:Logger:Debug(substitute('Found ABL App "&1" for WebApp "&2" (enabled: &3)':u,
                                                            cAblApp, pcWebApp, oWebapps:GetLogical(pcWebApp))).
                        return cAblApp.
                    end.
                end.
            end.
        end.

        this-object:Logger:Warn(substitute('No ABL App found for WebApp "&1"':u, pcWebApp)).
        return ''.

        catch err as Progress.Lang.Error:
            this-object:Logger:Error(substitute('Error in GetAblAppForWebApp: &1':u, err:GetMessage(1))).
            return ''.
        end catch.
    end method. // GetAblAppForWebApp

    /**
     * Scan catalina.properties for HTTP/HTTPS port configuration.
     * Updates the iPort variable with the discovered port number.
     */
    method protected void ScanCatalinaProperties ( ):
        define variable cFilePath    as character no-undo.
        define variable cLine        as character no-undo.
        define variable lcConfigTemp as longchar  no-undo.
        define variable iLines       as integer   no-undo.
        define variable iLine        as integer   no-undo.
        define variable iHttpPort    as integer   no-undo.
        define variable iHttpsPort   as integer   no-undo.
        define variable dLastDate    as datetime  no-undo.

        /* Examine the catalina.properties for info about the available ports. */
        file-info:file-name = substitute('&1/conf/catalina.properties':u, this-object:CatalinaBase).
        assign cFilePath = file-info:full-pathname.
        if cFilePath ne ? then do:
            /* Get the current date/time that the file was last modified. */
            assign dLastDate = datetime(file-info:file-mod-date, file-info:file-mod-time * 1000).

            if dLastDate ne dCBPropsLastLoaded then do:
                /* Mark down the current modified date/time for this file. */
                assign dCBPropsLastLoaded = dLastDate.

                this-object:Logger:Debug(substitute('Scanning catalina.properties: &1':u, cFilePath)).

                /* Read the file into a longchar value (avoids keeping the file open). */
                copy-lob from file cFilePath to lcConfigTemp no-error.

                assign iLines = num-entries(lcConfigTemp, '~n').
                if iLines ge 1 then cfgblk:
                do iLine = 1 to iLines:
                    assign cLine = trim(entry(iLine, lcConfigTemp, '~n')).

                    case true:
                        when cLine begins 'psc.as.http.port=':u then
                            assign iHttpPort = integer(trim(entry(2, cLine, '='))).
                        when cLine begins 'psc.as.https.port=':u then
                            assign iHttpsPort = integer(trim(entry(2, cLine, '='))).
                    end case.
                end. /* do iLines */

                /* Look to the same server at either the HTTP or HTTPS port for OEManager. */
                if iHttpPort gt 0 then
                    assign iPort = iHttpPort.
                else if iHttpsPort gt 0 then
                    assign iPort = iHttpsPort.

                this-object:Logger:Debug(substitute('Discovered ports - HTTP: &1, HTTPS: &2, Selected: &3':u,
                                                    iHttpPort, iHttpsPort, iPort)).

                assign lcConfigTemp = ?. /* Reset the variable. */
            end. /* file updated */
        end. /* catalina.properties */

        catch err as Progress.Lang.Error:
            this-object:Logger:Error(substitute('Error in ScanCatalinaProperties: &1':u, err:GetMessage(1))).
        end catch.
    end method. // ScanCatalinaProperties

    /**
     * Scan openedge.properties for ABL application and webapp configuration.
     * Builds a JSON structure mapping ABL apps to their webapps with enabled status.
     * Format: { "ablAppName": { "webapps": { "webappName": true/false } } }
     */
    method protected void ScanOpenEdgeProperties ( ):
        define variable cFilePath      as character  no-undo.
        define variable cLine          as character  no-undo.
        define variable lcConfigTemp   as longchar   no-undo.
        define variable iLines         as integer    no-undo.
        define variable iLine          as integer    no-undo.
        define variable dLastDate      as datetime   no-undo.
        define variable cSection       as character  no-undo.
        define variable cCurrentAblApp as character  no-undo.
        define variable cAblApp        as character  no-undo.
        define variable cWebApp        as character  no-undo.
        define variable iAdapterEnabled as integer   no-undo.
        define variable lAdapterEnabled as logical   no-undo.
        define variable oAppConfig     as JsonObject no-undo.
        define variable oWebapps       as JsonObject no-undo.

        /* Examine the openedge.properties for ABL app and webapp configuration. */
        file-info:file-name = substitute('&1/conf/openedge.properties':u, this-object:CatalinaBase).
        assign cFilePath = file-info:full-pathname.
        if cFilePath ne ? then do:
            /* Get the current date/time that the file was last modified. */
            assign dLastDate = datetime(file-info:file-mod-date, file-info:file-mod-time * 1000).

            if dLastDate ne dOEPropsLastLoaded then do:
                /* Mark down the current modified date/time for this file. */
                assign dOEPropsLastLoaded = dLastDate.

                /* Initialize/reset the config JSON structure. */
                assign oAppWebappConfig = new JsonObject().

                this-object:Logger:Debug(substitute('Scanning openedge.properties: &1':u, cFilePath)).

                /* Read the file into a longchar value (avoids keeping the file open). */
                copy-lob from file cFilePath to lcConfigTemp no-error.

                assign iLines = num-entries(lcConfigTemp, '~n').
                if iLines ge 1 then oeblk:
                do iLine = 1 to iLines:
                    assign cLine = trim(entry(iLine, lcConfigTemp, '~n')).

                    /* Skip comments and empty lines. */
                    if cLine begins '#':u or cLine eq '':u then
                        next oeblk.

                    /* Check for section headers like [AppServer.Agent.oepas1] or [oepas1.ROOT.WEB]. */
                    if cLine begins '[':u and cLine matches '*]':u then do:
                        assign cSection = trim(cLine, '[]':u).

                        /* Pattern: [AppServer.Agent.*] - Extract ABL app name from 3rd element. */
                        if cSection matches '*AppServer.Agent.*':u then do:
                            assign cCurrentAblApp = entry(3, cSection, '.').

                            /* Create ABL app entry in JSON if it doesn't exist. */
                            if (cCurrentAblApp gt '') eq true and
                               not oAppWebappConfig:Has(cCurrentAblApp) then do:
                                assign oAppConfig = new JsonObject().
                                assign oWebapps = new JsonObject().
                                oAppConfig:Add('webapps':u, oWebapps).
                                oAppWebappConfig:Add(cCurrentAblApp, oAppConfig).

                                this-object:Logger:Debug(substitute('Found ABL App from Agent section: &1':u,
                                                                    cCurrentAblApp)).
                            end.

                            /* Reset adapterEnabled for this section. */
                            assign iAdapterEnabled = ?.
                        end.

                        /* Pattern: [*.*.WEB] - Extract ABL app (1st) and webapp (2nd) names. */
                        else if cSection matches '*.*.WEB':u then do:
                            assign
                                cAblApp = entry(1, cSection, '.')
                                cWebApp = entry(2, cSection, '.')
                                cCurrentAblApp = cAblApp
                                .

                            /* Ensure ABL app exists in config. */
                            if (cAblApp gt '') eq true and
                               not oAppWebappConfig:Has(cAblApp) then do:
                                assign oAppConfig = new JsonObject().
                                assign oWebapps = new JsonObject().
                                oAppConfig:Add('webapps':u, oWebapps).
                                oAppWebappConfig:Add(cAblApp, oAppConfig).
                            end.

                            /* Get the webapps object for this ABL app. */
                            if (cAblApp gt '') eq true and (cWebApp gt '') eq true then do:
                                assign oAppConfig = oAppWebappConfig:GetJsonObject(cAblApp).
                                assign oWebapps = oAppConfig:GetJsonObject('webapps':u).

                                /* Add webapp entry if it doesn't exist (default to false). */
                                if not oWebapps:Has(cWebApp) then
                                    oWebapps:Add(cWebApp, false).

                                this-object:Logger:Debug(substitute('Found ABL App/WebApp from WEB section: &1 / &2':u,
                                                                    cAblApp, cWebApp)).
                            end.

                            /* Reset adapterEnabled for this section. */
                            assign iAdapterEnabled = ?.
                        end.
                        else
                            /* Not a section we care about. */
                            assign cCurrentAblApp = ''.
                    end. /* section header */

                    /* Look for adapterEnabled property within sections. */
                    else if cLine matches '*adapterEnabled=*':u and
                            (cCurrentAblApp gt '') eq true then do:
                        assign iAdapterEnabled = integer(trim(entry(2, cLine, '='))) no-error.
                        if iAdapterEnabled eq ? then
                            assign iAdapterEnabled = 0.

                        assign lAdapterEnabled = (iAdapterEnabled eq 1).

                        /* Update the most recently added webapp's enabled status. */
                        if (cWebApp gt '') eq true and
                           oAppWebappConfig:Has(cCurrentAblApp) then do:
                            assign oAppConfig = oAppWebappConfig:GetJsonObject(cCurrentAblApp).
                            assign oWebapps = oAppConfig:GetJsonObject('webapps':u).

                            if oWebapps:Has(cWebApp) then do:
                                oWebapps:Set(cWebApp, lAdapterEnabled).

                                this-object:Logger:Debug(substitute('Set enabled=&1 for &2 / &3':u,
                                                                    lAdapterEnabled, cCurrentAblApp, cWebApp)).
                            end.
                        end.
                    end.
                end. /* do iLines */

                /* Log the final JSON structure for debugging. */
                if valid-object(oAppWebappConfig) then
                    this-object:Logger:Debug(substitute('ABL App/WebApp Configuration JSON:~n&1':u, oAppWebappConfig:GetJsonText())).
                else
                    this-object:Logger:Warn('No ABL App/WebApp configuration was built').

                assign lcConfigTemp = ?. /* Reset the variable. */
            end. /* file updated */
        end. /* openedge.properties */
        else
            this-object:Logger:Warn(substitute('openedge.properties not found at: &1':u,
                                               substitute('&1/conf/openedge.properties':u, this-object:CatalinaBase))).

        catch err as Progress.Lang.Error:
            this-object:Logger:Error(substitute('Error in ScanOpenEdgeProperties: &1':u, err:GetMessage(1))).
        end catch.
    end method. // ScanOpenEdgeProperties

    /**
     * Discover and register available REST services for the current ABL application context.
     *
     * DISCOVERY LOGIC:
     * ----------------
     * 1. Extract the current webapp name from the incoming HTTP request (e.g., 'ROOT', 'webapp1', etc.)
     *
     * 2. Look up which ABL application relates to this webapp by consulting the configuration
     *    parsed from openedge.properties (happens regardless of WEB transport enabled status)
     *
     * 3. Build a list of paths to search for service mapping files (.gen/.map):
     *    a) CATALINA_BASE/openedge - Common location (always searched)
     *    b) CATALINA_BASE/ablapps/{ablApp}/openedge - Current ABL app location
     *    c) CATALINA_BASE/webapps/{webapp}/WEB-INF/openedge - For EACH webapp belonging
     *       to the current ABL app that has WEB transport enabled (enabled: true in config)
     *
     * 4. Register all services found in these paths with the ServiceRegistry
     *
     * RATIONALE:
     * ----------
     * - The incoming webapp determines the ABL application context (which AVM/session)
     * - All webapps in the same ABL app share the same ServiceRegistry (in-memory)
     * - We search ALL enabled webapps for that ABL app because services from any of
     *   them may be available in this shared registry
     * - Disabled webapps are skipped because without WEB transport, mapping files
     *   won't be used/processed, so there's no point searching those locations
     *
     * EXAMPLE:
     * --------
     * Request comes in on /webapp1
     * - webapp1 belongs to ABL app "oepas1"
     * - oepas1 has webapps: ROOT (WEB enabled), webapp1 (WEB enabled), webapp2 (WEB disabled)
     *
     * Will search:
     * - CATALINA_BASE/openedge
     * - CATALINA_BASE/ablapps/oepas1/openedge
     * - CATALINA_BASE/webapps/ROOT/WEB-INF/openedge
     * - CATALINA_BASE/webapps/webapp1/WEB-INF/openedge
     * - (CATALINA_BASE/webapps/webapp2/WEB-INF/openedge is skipped - WEB disabled)
     */
    method protected void Discovery ( ):
        define variable cSvcMapPath    as character  no-undo.
        define variable cSvcMapPaths   as character  no-undo.
        define variable iPath          as integer    no-undo.
        define variable iPaths         as integer    no-undo.
        define variable cPath          as character  no-undo.
        define variable cCurrentWebApp as character  no-undo.
        define variable cCurrentAblApp as character  no-undo.
        define variable oAppConfig     as JsonObject no-undo.
        define variable oWebapps       as JsonObject no-undo.
        define variable lWebAppEnabled as logical    no-undo.

        this-object:Logger:Debug(substitute('Performing Discovery; CATALINA_BASE: &1':u, this-object:CatalinaBase)).

        /* Scan configuration files for server info. */
        this-object:ScanCatalinaProperties().
        this-object:ScanOpenEdgeProperties().

        /* Determine which webapp is currently serving this request. */
        assign cCurrentWebApp = this-object:GetCurrentWebApp().
        this-object:Logger:Debug(substitute('Current WebApp: &1':u,
                                            if cCurrentWebApp gt '':u then cCurrentWebApp else '<unknown>':u)).

        /* Find the ABL application that owns this webapp. */
        if (cCurrentWebApp gt '') eq true then do:
            assign cCurrentAblApp = this-object:GetAblAppForWebApp(cCurrentWebApp).
            this-object:Logger:Debug(substitute('Resolved ABL App for WebApp "&1": &2':u,
                                                cCurrentWebApp,
                                                if cCurrentAblApp gt '':u then cCurrentAblApp else '<not found>':u)).
        end.
        else
            this-object:Logger:Warn('Unable to determine current webapp from request').

        /* Check if current webapp is enabled for WEB transport. */
        if (cCurrentAblApp gt '') eq true and
           (cCurrentWebApp gt '') eq true and
           valid-object(oAppWebappConfig) then do:
            if oAppWebappConfig:Has(cCurrentAblApp) then do:
                assign oAppConfig = oAppWebappConfig:GetJsonObject(cCurrentAblApp).
                if oAppConfig:Has('webapps':u) then do:
                    assign oWebapps = oAppConfig:GetJsonObject('webapps':u).
                    if oWebapps:Has(cCurrentWebApp) then
                        assign lWebAppEnabled = oWebapps:GetLogical(cCurrentWebApp).
                end.
            end.

            this-object:Logger:Debug(substitute('Current WebApp &1/&2 WEB transport: &3':u,
                                               cCurrentAblApp,
                                               cCurrentWebApp,
                                               if lWebAppEnabled then 'ENABLED':u else 'DISABLED':u)).

            if not lWebAppEnabled then
                this-object:Logger:Warn(substitute('Current WebApp &1/&2 does not have WEB transport enabled':u,
                                                   cCurrentAblApp, cCurrentWebApp)).
        end.
        else if not valid-object(oAppWebappConfig) then
            this-object:Logger:Warn('App/WebApp configuration not available - cannot determine webapp status').

        /* Start some of the internal registries by accessing the static properties. */
        ArgumentValueWriterRegistry:Registry.
        BodyWriterRegistry:Registry.
        EntityWriterRegistry:Registry.
        LogFilterBuilderRegistry:Registry.
        LoggerFilterRegistry:Registry.
        OperationHandlerRegistry:Registry.
        ResponseElementWriterRegistry:Registry.
        ServiceRegistry:Registry.

        /**
         * By default the ServiceRegistry will only be populated with data as a service is utilized.
         * We need to speed up this process to have all the services available for display, which
         * requires us to load all services available. We check conventional locations based on
         * discovered ABL apps and webapps.
         */

        /* Check for environment variable override first. */
        assign cSvcMapPaths = os-getenv('SERVICEMAP_PATHS':u).
        if (cSvcMapPaths gt '') eq true then
            this-object:Logger:Debug(substitute('Using service map paths from environment variable: &1':u, cSvcMapPaths)).
        else do:
            /**
             * Build paths based on current ABL application context:
             * 1. Always search CATALINA_BASE/openedge (common location)
             * 2. Search CATALINA_BASE/ablapps/<currentApp>/openedge for current ABL app
             * 3. Search CATALINA_BASE/webapps/<webapp>/WEB-INF/openedge for ALL webapps
             *    belonging to the current ABL app that have WEB transport enabled
             */

            /* 1. Common location - always included. */
            assign cSvcMapPaths = substitute('&1/openedge':u, this-object:CatalinaBase).

            /* 2. & 3. Current ABL app location and all enabled webapps for that app. */
            if (cCurrentAblApp gt '') eq true then do:
                /* ABL application location. */
                assign cSvcMapPaths = cSvcMapPaths + cPathSeparator +
                    substitute('&1/ablapps/&2/openedge':u, this-object:CatalinaBase, cCurrentAblApp).

                /* Add all WEB-enabled webapps for this ABL app. */
                if valid-object(oAppWebappConfig) and
                   oAppWebappConfig:Has(cCurrentAblApp) then do:
                    define variable cWebAppNames as character no-undo extent.
                    define variable iWebApp      as integer   no-undo.
                    define variable cWebAppName  as character no-undo.

                    assign oAppConfig = oAppWebappConfig:GetJsonObject(cCurrentAblApp).
                    if oAppConfig:Has('webapps':u) then do:
                        assign oWebapps = oAppConfig:GetJsonObject('webapps':u).
                        assign cWebAppNames = oWebapps:GetNames().

                        /* Add path for each enabled webapp. */
                        do iWebApp = 1 to extent(cWebAppNames):
                            assign cWebAppName = cWebAppNames[iWebApp].
                            if oWebapps:GetLogical(cWebAppName) eq true then do:
                                assign cSvcMapPaths = cSvcMapPaths + cPathSeparator +
                                    substitute('&1/webapps/&2/WEB-INF/openedge':u,
                                               this-object:CatalinaBase, cWebAppName).
                                this-object:Logger:Debug(substitute('Added path for enabled webapp: &1':u, cWebAppName)).
                            end.
                            else
                                this-object:Logger:Debug(substitute('Skipping disabled webapp: &1':u, cWebAppName)).
                        end.
                    end.
                end.

                this-object:Logger:Debug(substitute('Building paths for ABL App: &1':u, cCurrentAblApp)).
            end.
            else do:
                /* If we can't determine current context, log warning but still use common location. */
                this-object:Logger:Warn('Unable to determine current ABL app - only searching common locations').
            end.

            this-object:Logger:Debug(substitute('Built service map paths: &1':u, cSvcMapPaths)).
        end.

        /* Log summary of discovery context. */
        this-object:Logger:Debug(substitute('Discovery Summary - WebApp: &1, ABL App: &2, Status: &3, Paths to search: &4':u,
                                            if cCurrentWebApp gt '':u then cCurrentWebApp else '<unknown>':u,
                                            if cCurrentAblApp gt '':u then cCurrentAblApp else '<unknown>':u,
                                            if lWebAppEnabled then 'ENABLED':u else 'DISABLED':u,
                                            num-entries(cSvcMapPaths, cPathSeparator))).

        /* Register services from all discovered paths. */
        if (cSvcMapPaths gt '') eq true then do:
            assign iPaths = num-entries(cSvcMapPaths, cPathSeparator).

            do iPath = 1 to iPaths:
                assign cPath = trim(entry(iPath, cSvcMapPaths, cPathSeparator)).

                if (cPath gt '') eq true then do:
                    /* Check if path exists before attempting to register. */
                    file-info:file-name = cPath.
                    if file-info:full-pathname ne ? then do:
                        this-object:Logger:Debug(substitute('Registering services from folder: &1':u, cPath)).
                        ServiceRegistry:RegisterAllFromFolder(cPath).
                    end.
                    else
                        this-object:Logger:Debug(substitute('Path does not exist, skipping: &1':u, cPath)).
                end.
            end.
        end.
        else
            this-object:Logger:Warn('No service map paths found - no services will be registered').

        catch err as Progress.Lang.Error:
            this-object:Logger:Error(substitute('Error in Discovery: &1':u, err:GetMessage(1))).
        end catch.
    end method. // Discovery

    /**
     * Get the full pathname of a file or directory
     * Will return with '/' as the directory separator
     * Paths are returned without trailing slashes
     */
    method protected character GetFullPathname ( input pcFile as character ):
        var character cReturn.

        file-info:filename = pcFile.
        assign cReturn = right-trim(replace(file-info:full-pathname, StringConstant:BACKSLASH, '/':u), '/':u).

        return cReturn.
    end method. // GetFullPathname

    /**
     * Get the scheme (protocol) from the current web request
     * Checks HTTPS and REQUEST_SCHEME CGI environment variables
     * Returns 'http' or 'https' based on the request
     */
    method protected character GetScheme ( ):
        var character cScheme, cHttps.

        // Check if HTTPS is enabled via the HTTPS CGI variable
        assign cHttps = web-context:get-cgi-value('env':u, 'HTTPS':u).
        if cHttps eq 'on':u or cHttps eq '1':u then
            return 'https':u.

        // Check REQUEST_SCHEME if available
        assign cScheme = web-context:get-cgi-value('env':u, 'REQUEST_SCHEME':u).
        if cScheme eq 'https':u then
            return 'https':u.

        // Default to http
        return 'http':u.
    end method. // GetScheme

    /**
     * Get the hostname from the current web request
     * Extracts SERVER_NAME from the CGI environment variables
     * Returns 'localhost' as fallback if not available
     */
    method protected character GetHostname ( ):
        var character cHostname.

        // Get the server name from the web request CGI variables
        assign cHostname = web-context:get-cgi-value('env':u, 'SERVER_NAME':u).

        // Return localhost as fallback if hostname not available
        if (cHostname gt '') ne true then
            assign cHostname = 'localhost':u.

        return cHostname.
    end method. // GetHostname

    /**
     * Get the context path (webapp) from the current web request
     * Extracts CONTEXT_PATH from the CGI environment variables
     * Returns '' as fallback if not available
     */
    method protected character GetContext ( ):
        var character cContext.

        // Get the context path from the web request CGI variables
        assign cContext = web-context:get-cgi-value('env':u, 'CONTEXT_PATH':u).

        // Return empty string (for ROOT) as fallback if context path not available
        if (cContext gt '') ne true then
            assign cContext = '':u.

        return cContext.
    end method. // GetContext

    /**
     * Return a JSON object with an Open API v3.0 formatted description of resource endpoints.
     * This utilizes the static ServiceRegistry created at first use of the WEB-based service.
     */
    method protected JsonObject GetOpenApiCatalog ( ):
        define variable oServiceWriter   as IOpenAPIServiceWriter no-undo.
        define variable cScheme          as character             no-undo.
        define variable cHostname        as character             no-undo.
        define variable cDefaultContext  as character             no-undo.
        define variable cDefaultBasePath as character             no-undo.

        // Get the hostname and scheme used to reach this server.
        assign
            cScheme          = this-object:GetScheme()
            cHostname        = this-object:GetHostname()
            cDefaultContext  = this-object:GetContext()
            cDefaultBasePath = '/' + OpenEdge.Web.DataObject.DataObjectHandler:HANDLER_PREFIX
            .

        this-object:Logger:Debug(substitute('Server Info - Scheme: &1, Hostname: &2, Context: &3, BasePath: &4':u,
                                            cScheme, cHostname, cDefaultContext, cDefaultBasePath)).

        // Always create a new service writer instance with the current context.
        assign oServiceWriter = new OpenAPI31ServiceWriter().

        if valid-object(oServiceWriter) then do:
            // Open() applies the user context and creates the structure.
            oServiceWriter:SetDocumentVersion(oApiVersion:ToString())
                          :SetServer(cScheme, cHostname, iPort, cDefaultContext, cDefaultBasePath)
                          :Open().

            // Write all available services and Close as normal.
            oServiceWriter:Write(ServiceRegistry:GetServices()).
            oServiceWriter:Close().

            this-object:Logger:Debug(substitute('Catalog Size: &1':u,
                                                length(cast(oServiceWriter:Value, JsonObject):GetJsonText(), 'raw':u))).

            // Return the catalog object from the service writer.
            return cast(oServiceWriter:Value, JsonObject).
        end.
        else
            this-object:Logger:Error('Failed to create OpenAPI31ServiceWriter instance').

        // Return an empty object if the writer was never valid.
        return new JsonObject().

        catch err as Progress.Lang.Error:
            this-object:Logger:Error(substitute('Error in GetOpenApiCatalog: &1':u, err:GetMessage(1))).
            if session:error-stack-trace then
                this-object:Logger:Error(err:CallStack).
            return new JsonObject().
        end catch.
        finally:
            delete object oServiceWriter no-error.
        end finally.
    end method. // GetOpenApiCatalog

    /* Default handler for the HTTP GET method

       @param IWebRequest The request being serviced
       @return integer An optional status code. A zero or null value means this
                       method will deal with all errors */
    method override protected integer HandleGet ( input poRequest as IWebRequest ):
        define variable oResponse as IHttpResponse no-undo.

        this-object:Logger:Debug(substitute('HandleGet Called - PathInfo: &1, UriTemplate: &2':u,
                                            poRequest:PathInfo, poRequest:UriTemplate)).

        // Log in case we want to see who has requested this
        this-object:Logger:Trace(substitute('Catalog request received from user: &1 at &2 on &3:&4',
                                            poRequest:RemoteUser,
                                            poRequest:RemoteAddress,
                                            poRequest:RemoteHost,
                                            poRequest:RemotePort)).

        // ONLY allow instance/webapp/web/<template-uri> and nothing after
        if trim(poRequest:PathInfo, '/':u) ne trim(poRequest:UriTemplate, '/':u) then
        do:
            this-object:Logger:Debug('Path validation failed - returning 404').
            {&_proparse_ prolint-nowarn(overflow)}
            return integer(StatusCodeEnum:NotFound:GetValue()). // 404
        end.

        if not CanAcceptContentType(poRequest, 'application/json':u) then
        do:
            this-object:Logger:Debug('Content type validation failed - returning 415').
            {&_proparse_ prolint-nowarn(overflow)}
            return integer(StatusCodeEnum:UnsupportedMediaType:GetValue()). // 415
        end.

        assign
            oResponse             = new WebResponse(StatusCodeEnum:OK)
            oResponse:ContentType = 'application/json':u
            .

        do on error undo, throw:
            // Generate the OpenAPI catalog using the static ServiceRegistry data.
            oResponse:Entity = this-object:GetOpenApiCatalog().

            catch catalogError as Progress.Lang.Error:
                // Error conditions are treated as an internal server error.
                this-object:Logger:Error(substitute('Request from user: &1 at &2 on &3:&4 resulted in an error.':u,
                                                    poRequest:RemoteUser,
                                                    poRequest:RemoteAddress,
                                                    poRequest:RemoteHost,
                                                    poRequest:RemotePort), new SendExceptionError(StatusCodeEnum:InternalServerError, catalogError)).
                {&_proparse_ prolint-nowarn(overflow)}
                return integer(StatusCodeEnum:InternalServerError:GetValue()). // 500
            end catch.
            catch catalogStop as Progress.Lang.Stop:
                // Stop conditions are treated as a request timeout (eg. in the case of a stop-after).
                this-object:Logger:Error(substitute('Request from user: &1 at &2 on &3:&4 resulted in a stop.':u,
                                                    poRequest:RemoteUser,
                                                    poRequest:RemoteAddress,
                                                    poRequest:RemoteHost,
                                                    poRequest:RemotePort), new SendExceptionError(StatusCodeEnum:RequestTimeOut, catalogStop)).
                {&_proparse_ prolint-nowarn(overflow)}
                return integer(StatusCodeEnum:RequestTimeOut:GetValue()). // 408
            end catch.
        end.

        // write the response, whatever it is
        WriteResponse(oResponse).

        return 0.
    end method.

    /** Writes the response using the WebResponseWriter.

        This method allows us to unit test this handler (via gradle/batch).

        @param IHttpResponse The response to write */
    method protected void WriteResponse(input poResponse as IHttpResponse):
        define variable writer as WebResponseWriter no-undo.

        this-object:Logger:Debug(substitute('WriteResponse - Status: &1, ContentType: &2':u,
                                            poResponse:StatusCode, poResponse:ContentType)).

        assign writer = new WebResponseWriter(poResponse).
        writer:Open().
        writer:Close().
    end method.

    method override protected integer HandleNotAllowedMethod(input poRequest as IWebRequest):
        {&_proparse_ prolint-nowarn(overflow)}
        return integer(StatusCodeEnum:MethodNotAllowed:GetValue()). // 405
    end method.

    method override protected integer HandleNotImplemented(input poRequest as IWebRequest):
        {&_proparse_ prolint-nowarn(overflow)}
        return integer(StatusCodeEnum:NotImplemented:GetValue()). // 501
    end method.

end class.