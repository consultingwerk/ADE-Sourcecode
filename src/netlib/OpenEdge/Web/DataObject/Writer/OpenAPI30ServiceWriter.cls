/* *************************************************************************************************************************
Copyright (c) 2018,2021,2023-2026 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OpenAPI30ServiceWriter
    Purpose     : Writes a DataObjectService to a OpenApi (Swagger) 3.0 spec
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2018-09-20
    Notes       : Supported Specification History:
        Starting Implementation: https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md
        Latest Version (1/2026): https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.4.md
------------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.SemanticVersion.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.URI.
using OpenEdge.Security.Principal.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.DataObject.TargetTypeEnum.
using OpenEdge.Web.DataObject.Writer.DataObjectServiceWriter.
using OpenEdge.Web.DataObject.Writer.IOpenAPIServiceWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Web.DataObject.Writer.OpenAPI30ServiceWriter inherits DataObjectServiceWriter implements IOpenAPIServiceWriter:

    define static public property OPEN_API_VERSION as SemanticVersion no-undo
        get.
        protected set.

    // Default server configuration values based on expected product defaults
    define protected variable cDefaultScheme   as character no-undo initial "http":u. // Assume HTTP by default
    define protected variable cDefaultHost     as character no-undo initial "localhost":u. // Default hostname
    define protected variable iDefaultPort     as integer   no-undo initial 8810. // Default port (assumed for 'oepas1' instance)
    define protected variable cDefaultContext  as character no-undo initial "":u. // Default context path (empty/blank = ROOT)
    define protected variable cDefaultBasePath as character no-undo initial "/pdo":u. // Defaults to Progress Data Object endpoint
    define protected variable cDocApiVersion   as character no-undo initial "1.0.0":u. // Defaults to 1.0.0 for the application

    // User-provided values via decorator pattern (AddDocumentVersion, AddServer)
    define protected variable cUserDocVersion as character no-undo initial ?.
    define protected variable cUserScheme     as character no-undo initial ?.
    define protected variable cUserHost       as character no-undo initial ?.
    define protected variable iUserPort       as integer   no-undo initial ?.
    define protected variable cUserContext    as character no-undo initial ?.
    define protected variable cUserBasePath   as character no-undo initial ?.

    // Security scheme configuration (set via UseBasicAuth, UseBearerAuth, etc.)
    define protected variable cSecuritySchemeType as character no-undo initial ?.
    define protected variable cSecuritySchemeName as character no-undo initial ?.
    define protected variable cBasicRealm         as character no-undo initial ?.
    define protected variable cBearerFormat       as character no-undo initial ?.
    define protected variable cSecurityDesc       as character no-undo initial ?.
    define protected variable lIncludeRoleOutput  as logical   no-undo initial false.

    // Cache the current user's Client-Principal token for authorization checks
    define private variable oCachedPrincipal as Principal no-undo.

    // Default static constructor
    constructor static OpenAPI30ServiceWriter ():
        assign OPEN_API_VERSION = new SemanticVersion(3,0,4).
    end constructor.

    // Default constructor
    constructor public OpenAPI30ServiceWriter ():
        super(get-class(JsonObject)).
    end constructor.

    /**
     * Basic OpenAPI 3.0.x specific logic for JSON Schema compliance
     */

    /**
        Adds nullable property to a schema object for OpenAPI 3.0.x compliance.
        This method is designed to be overridden in later spec versions (e.g., 3.1.x, 3.2.x)
        where nullable handling differs per JSON Schema Draft 2020-12.

        @param JsonObject The schema object to add nullable property to
      */
    method protected void AddNullableProperty (input pSchemaObject as JsonObject):
        pSchemaObject:Add('nullable':u, true).
    end method. // AddNullableProperty

    /**
        Applies format to a schema object for type validation hints.
        This method is designed to be overridden in later spec versions (e.g., 3.2.0)
        to handle format differently, particularly for binary data which uses
        contentEncoding/contentMediaType in JSON Schema Draft 2020-12.

        @param JsonObject The schema object to apply format to
        @param character The format value (e.g., 'date', 'date-time', 'int32', 'binary')
      */
    method protected void ApplyFieldFormat (input pSchemaObject as JsonObject,
                                            input pFormat       as character):
        if pFormat gt '':u then
            pSchemaObject:Add('format':u, pFormat).
    end method. // ApplyFieldFormat

    /**
        Marks a single field schema as required for OpenAPI 3.0.x compliance.
        Called per-field from CreateFieldSchema and CreateArrayFieldSchema when
        the field belongs to a unique index.
        This method is designed to be overridden in later spec versions (e.g., 3.1.x)
        where required is expressed as an array on the parent items object instead.

        @param JsonObject The field schema object to mark as required
      */
    method protected void MarkRequiredField (input pFieldSchema  as JsonObject,
                                             input pFieldName    as character,
                                             input pRequiredFlds as character):
        if lookup(pFieldName, pRequiredFlds) gt 0 then
            pFieldSchema:Add('required':u, true).
    end method. // MarkRequiredField

    /**
        Marks required fields at the table (items) level after all fields are built.
        Called once per table from WriteTable with the complete unique field list.
        This is a no-op in OpenAPI 3.0.x — required is applied per-field by MarkRequiredField.
        Designed to be overridden in later spec versions (e.g., 3.1.x) where required
        is expressed as a 'required' array on the parent items schema object.

        @param JsonObject The items schema object of the table
        @param character Comma-delimited list of unique (required) field names
      */
    method protected void MarkRequiredFields (input pItemsSchema  as JsonObject,
                                              input pRequiredFlds as character):
        // OpenAPI 3.0.x: no-op — required is applied inline per field by MarkRequiredField
    end method. // MarkRequiredFields

    /**
     * Core logic and helper methods
     */

    /**
        Initializes the writer and creates the root OpenAPI document structure.
        Creates a new JsonObject representing the OpenAPI document if not already present.
        After creating the structure, applies any user-provided context (version, servers).
      */
    method override public void Open ():
        // Clean up any existing cached Principal from previous use
        if valid-object(oCachedPrincipal) then
            delete object oCachedPrincipal no-error.
        assign oCachedPrincipal = ?.

        // If nothing's passed in, create an instance of the Argument Type
        if not valid-object(this-object:Value) then
            assign this-object:Value = WriteServiceRoot().

        // Apply any user-provided context after the JsonObject is created.
        this-object:ApplyUserContext().

        // Initialize/cache the current user's Principal for authorization checks.
        assign oCachedPrincipal = this-object:GetCurrentPrincipal().

        super:Open().
    end method. // Open

    /**
        Writes service data to the OpenAPI document.
        Public override to satisfy interface contract.

        @param DataObjectService The service to write to the document
      */
    method override public void Write (input poData as Progress.Lang.Object extent):
        super:Write(poData).
    end method. // Write

    /**
        Finalizes and closes the writer.
        Cleans up cached Principal object and performs final service cleanup.
        Public override to satisfy interface contract.
      */
    method override public void Close ():
        // Remove services that have no accessible operations
        this-object:RemoveEmptyServices().

        // Clean up the cached Principal object
        if valid-object(oCachedPrincipal) then
            delete object oCachedPrincipal no-error.
        assign oCachedPrincipal = ?.

        super:Close().
    end method. // Close

    /**
        Sets the document API version for the OpenAPI specification.
        Uses fluent API pattern to allow method chaining.
        Call before Open() to override the default version.

        @param character The API version string (eg. "3.1.4")
        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter SetDocumentVersion (input pcVersion as character):
        if (pcVersion gt '':u) eq true then
            assign cUserDocVersion = pcVersion.
        return this-object.
    end method. // SetDocumentVersion

    /**
        Sets a direct server configuration to be inserted as the first server entry.
        Uses fluent API pattern to allow method chaining.
        If called multiple times, the last call wins.
        Call before Open() to add a direct server URL.
        Also updates default values for parameterized servers.

        @param character Scheme (http/https), ? or empty to use default
        @param character Hostname, ? or empty to use default
        @param integer Port number, ? or 0 to use default
        @param character Context path, ? or empty to use default
        @param character Base path, ? or empty to use default
        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter SetServer (input pcScheme   as character,
                                                   input pcHost     as character,
                                                   input piPort     as integer,
                                                   input pcContext  as character,
                                                   input pcBasePath as character):
        // Store values - last call wins
        assign
            cUserScheme   = pcScheme
            cUserHost     = pcHost
            iUserPort     = piPort
            cUserContext  = pcContext
            cUserBasePath = pcBasePath
            .

        // Also update defaults for parameterized servers with provided values
        if (pcScheme gt '':u) eq true then
            assign cDefaultScheme = pcScheme.
        if (pcHost gt '':u) eq true then
            assign cDefaultHost = pcHost.
        if (piPort ne ? and piPort gt 0) then
            assign iDefaultPort = piPort.
        if (pcContext gt '':u) eq true then
            assign cDefaultContext = pcContext.
        if (pcBasePath gt '':u) eq true then
            assign cDefaultBasePath = pcBasePath.

        return this-object.
    end method. // SetServer

    /**
        Enables the inclusion of role requirements in the OpenAPI document.
        By default, role names are not exposed for security reasons.
        Call this method to opt-in to documenting specific role requirements
        either via standard OpenAPI security requirements or x-required-roles extension.
        Uses fluent API pattern to allow method chaining.

        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter IncludeRoleRequirements ():
        assign lIncludeRoleOutput = true.
        return this-object.
    end method. // IncludeRoleRequirements

    /**
        Configures HTTP Basic Authentication as the security scheme.
        This is used when client.login.model is 'basic', 'form', or 'container'.
        Call before Open() to include security scheme in the generated spec.
        Uses a default description.

        @param character Realm name (e.g., from http.all.realm property)
        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter UseBasicAuth (input pcRealm as character):
        return this-object:UseBasicAuth(pcRealm, '':u).
    end method. // UseBasicAuth

    /**
        Configures HTTP Basic Authentication as the security scheme with custom description.
        This is used when client.login.model is 'basic', 'form', or 'container'.
        Call before Open() to include security scheme in the generated spec.
        Throws an error if a different security scheme is already configured.

        @param character Realm name (e.g., from http.all.realm property)
        @param character Custom description for the scheme
        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter UseBasicAuth (input pcRealm       as character,
                                                      input pcDescription as character):
        // Warn if overriding an existing security scheme
        if cSecuritySchemeName ne ? and cSecuritySchemeName ne '':u and cSecuritySchemeName ne 'basicAuth':u then
            this-object:Logger:Warn(substitute('Security scheme "&1" is being overridden with Basic Auth. Only one security scheme is allowed per OpenAPI document.':u,
                                               cSecuritySchemeName)).

        assign
            cSecuritySchemeType = 'http':u
            cSecuritySchemeName = 'basicAuth':u
            cBasicRealm         = pcRealm
            cSecurityDesc       = pcDescription
            .
        return this-object.
    end method. // UseBasicAuth

    /**
        Configures Bearer token authentication as the security scheme.
        This is used when client.login.model is 'sso', 'oauth2', or 'saml'.
        Call before Open() to include security scheme in the generated spec.
        Uses a default description.

        @param character Bearer format (e.g., 'JWT', 'Client-Principal', 'SAML')
        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter UseBearerAuth (input pcFormat as character):
        return this-object:UseBearerAuth(pcFormat, '':u).
    end method. // UseBearerAuth

    /**
        Configures Bearer token authentication as the security scheme with custom description.
        This is used when client.login.model is 'sso', 'oauth2', or 'saml'.
        Call before Open() to include security scheme in the generated spec.
        Throws an error if a different security scheme is already configured.

        @param character Bearer format (e.g., 'JWT', 'Client-Principal', 'SAML')
        @param character Custom description for the scheme
        @return IOpenAPIServiceWriter Returns this instance for method chaining
      */
    method public IOpenAPIServiceWriter UseBearerAuth (input pcFormat      as character,
                                                       input pcDescription as character):
        // Warn if overriding an existing security scheme
        if cSecuritySchemeName ne ? and cSecuritySchemeName ne '':u and cSecuritySchemeName ne 'bearerAuth':u then
            this-object:Logger:Warn(substitute('Security scheme "&1" is being overridden with Bearer Auth. Only one security scheme is allowed per OpenAPI document.':u,
                                               cSecuritySchemeName)).

        assign
            cSecuritySchemeType = 'http':u
            cSecuritySchemeName = 'bearerAuth':u
            cBearerFormat       = pcFormat
            cSecurityDesc       = pcDescription
            .
        return this-object.
    end method. // UseBearerAuth

    /**
        Applies user-provided context (document version, direct server) to the OpenAPI document.
        Called automatically by Open() after the JsonObject structure is created.
        Modifies the existing JsonObject to insert direct server as first entry and update version.
      */
    method protected void ApplyUserContext ():
        define variable docRoot       as JsonObject no-undo.
        define variable serversArray  as JsonArray  no-undo.
        define variable directServer  as JsonObject no-undo.
        define variable directUrl     as character  no-undo.
        define variable infoObj       as JsonObject no-undo.

        if not valid-object(this-object:Value) then
            return.

        assign docRoot = cast(this-object:Value, JsonObject).

        // Update document version if provided
        if cUserDocVersion ne ? and (cUserDocVersion gt '':u) eq true then
        do:
            if docRoot:Has('info':u) then
            do:
                assign infoObj = docRoot:GetJsonObject('info':u).
                if infoObj:Has('version':u) then
                    infoObj:Set('version':u, cUserDocVersion).
                else
                    infoObj:Add('version':u, cUserDocVersion).
            end.
        end.

        // Add direct server as first entry if any user values were provided
        if cUserScheme ne ? or cUserHost ne ? or iUserPort ne ? or
           cUserContext ne ? or cUserBasePath ne ? then
        do:
            if docRoot:Has('servers':u) then
            do:
                assign serversArray = docRoot:GetJsonArray('servers':u).

                // Build direct URL using user values where provided, defaults otherwise.
                assign directUrl = substitute("&1://&2:&3&4/web&5":u,
                                             (if cUserScheme ne ? and (cUserScheme gt '':u) eq true then cUserScheme else cDefaultScheme),
                                             (if cUserHost ne ? and (cUserHost gt '':u) eq true then cUserHost else cDefaultHost),
                                             (if iUserPort ne ? and iUserPort gt 0 then string(iUserPort) else string(iDefaultPort)),
                                             (if cUserContext ne ? and (cUserContext gt '':u) eq true then cUserContext else cDefaultContext),
                                             (if cUserBasePath ne ? and (cUserBasePath gt '':u) eq true then cUserBasePath else cDefaultBasePath)).

                // Create and insert direct server as first entry.
                assign directServer = new JsonObject().
                directServer:Add('url':u, directUrl).
                directServer:Add('description':u, 'Direct server configuration':u).

                // Insert at position 0 (first entry) as the JSON array is zero-based.
                serversArray:Add(0, directServer).
            end.
        end.
    end method. // ApplyUserContext

    /**
        Creates the default server configuration array for OpenAPI document.
        Includes both absolute and relative path server configurations with
        parameterized variables for scheme, host, port, context, and basePath.
        Note: Direct server entries are added by ApplyUserContext() after this method runs.

        @return JsonArray Array of server configuration objects
      */
    method protected JsonArray WriteDefaultServers ():
        define variable servers       as JsonArray  no-undo.
        define variable arrayData     as JsonArray  no-undo.
        define variable defaultServer as JsonObject no-undo.
        define variable varData       as JsonObject no-undo.
        define variable childData     as JsonObject no-undo.

        assign servers = new JsonArray().

        // Add parameterized absolute path server
        assign
            defaultServer = new JsonObject()
            childData     = new JsonObject()
            .

        servers:Add(defaultServer).

        defaultServer:Add('url':u, '~{scheme}://~{host}:~{port}~{ctx}/web~{basePath}':u).
        defaultServer:Add('description':u, 'Default server configuration':u).
        defaultServer:Add('variables':u, childData).

        assign
            varData   = new JsonObject()
            arrayData = new JsonArray()
            .
        childData:Add('scheme':u, varData).
        varData:Add('description':u, 'Protocol for accessing the service (http or https)':u).
        varData:Add('enum':u, arrayData).
        arrayData:Add('http':u).
        arrayData:Add('https':u).
        varData:Add('default':u, cDefaultScheme).

        assign varData = new JsonObject().
        childData:Add('host':u, varData).
        varData:Add('description':u, 'Server hostname or IP. Should be the public FQDN used to access the application':u).
        varData:Add('default':u, cDefaultHost).

        assign varData = new JsonObject().
        childData:Add('port':u, varData).
        varData:Add('description':u, 'TCP port number where the application server listens, appropriate to the scheme':u).
        varData:Add('default':u, string(iDefaultPort)).

        assign varData = new JsonObject().
        childData:Add('ctx':u, varData).
        varData:Add('description':u, 'The webapp/context for this service. Empty/blank indicates ROOT':u).
        varData:Add('default':u, cDefaultContext).

        assign varData = new JsonObject().
        childData:Add('basePath':u, varData).
        varData:Add('description':u, 'Base path for the service endpoint (e.g., /pdo for Progress Data Object)':u).
        varData:Add('default':u, cDefaultBasePath).

        // relative path. will work relative to the OpenApi doc location
        assign
            defaultServer = new JsonObject()
            childData     = new JsonObject()
            .
        servers:Add(defaultServer).

        defaultServer:Add('url':u, '~{ctx}/web~{basePath}':u).
        defaultServer:Add('description':u, 'Default relative-path server configuration':u).
        defaultServer:Add('variables':u, childData).

        assign varData = new JsonObject().
        childData:Add('ctx':u, varData).
        varData:Add('description':u, 'The webapp/context for this service. Empty/blank indicates ROOT':u).
        varData:Add('default':u, cDefaultContext).

        assign varData = new JsonObject().
        childData:Add('basePath':u, varData).
        varData:Add('description':u, 'Base path for the service endpoint (eg. /pdo, /api, etc.)':u).
        varData:Add('default':u, cDefaultBasePath).
        return servers.
    end method. // WriteDefaultServers

    /**
        Creates the info section of the OpenAPI document.
        Includes title, description, terms of service, and version information.

        @return JsonObject The info object for the OpenAPI document
      */
    method protected JsonObject WriteInfo ():
        define variable infoData  as JsonObject no-undo.
        define variable childData as JsonObject no-undo.

        assign infoData = new JsonObject().
        //string  Required. The title of the application.
        infoData:Add('title':u, 'OpenAPI Documentation':u).

        //string  A short description of the application. GFM syntax can be used for rich text representation.
        infoData:Add('description':u, 'Provides APIs for DataObjectHandler-based services':u).

        //string  The Terms of Service for the API.
        // Omitted - add when needed rather than setting to empty or invalid values.
        //infoData:Add('termsOfService':u, '':u).

        //Object  The contact information for the exposed API.
        // Omitted - add when needed rather than setting to empty or invalid values.
        // assign childData = new JsonObject().
        // infoData:Add('contact':u, childData).
        // childData:Add('name':u, '':u).
        // childData:Add('url':u, '':u).
        // childData:Add('email':u, '':u).

        //Object  The license information for the exposed API.
        // Omitted - add when needed rather than setting to empty or invalid values.
        // assign childData = new JsonObject().
        // infoData:Add('license':u, childData).
        // childData:Add('name':u, '':u).
        // childData:Add('url':u, '':u).

        // The version of the OpenAPI document (which is distinct from the OpenAPI Specification
        // version or the API implementation version).
        infoData:Add('version':u, cDocApiVersion).

        return infoData.
    end method. // WriteInfo

    /**
        Creates the root OpenAPI document structure.
        Initializes all required sections including openapi version, info, servers,
        paths, components (with schemas), security, and tags.

        @return JsonObject The root OpenAPI document object
      */
    method protected JsonObject WriteServiceRoot():
        define variable svcJson   as JsonObject no-undo.
        define variable childData as JsonObject no-undo.

        assign
            svcJson   = new JsonObject()
            childData = new JsonObject()
            .

        // Semantic version of the OpenAPI Specification being used.
        // Used by tooling to interpret the document (distinct from API version).
        svcJson:Add('openapi':u, string(OPEN_API_VERSION)).

        // Metadata about the API (title, version, description, etc.).
        svcJson:Add('info':u, this-object:WriteInfo()).

        // Connectivity information for target servers.
        // Defaults to url "/" if omitted. Includes parameterized and direct URLs.
        svcJson:Add('servers':u, this-object:WriteDefaultServers()).

        // The available paths and operations for the API.
        svcJson:Add('paths':u, new JsonObject()).

        // Reusable schemas and security schemes for the API specification.
        assign childData = new JsonObject().
        svcJson:Add('components':u, childData).
        childData:Add('schemas':u, this-object:WriteDefaultSchemas()).
        this-object:WriteSecuritySchemes(childData).

        // Global security requirements applied to all operations by default.
        // Operations can override this. Only added when a security scheme is configured.
        if cSecuritySchemeName gt '':u then
            svcJson:Add('security':u, new JsonArray()).

        // Organizational metadata for grouping operations.
        // Operations reference tags; undeclared tags may be organized by tooling.
        svcJson:Add('tags':u, new JsonArray()).

        // externalDocs: Omitted - add when needed rather than setting to null.

        return svcJson.
    end method. // WriteServiceRoot

    /**
        Create the default JSON object for schemas.

        @return JsonObject The default schema object
      */
    method protected JsonObject WriteDefaultSchemas ():
        return new JsonObject().
    end method. // WriteDefaultSchemas

    /**
        Retrieves or creates a path operation JSON object for a specific URI and HTTP method.
        Constructs the full path from service name and URI, creates the operation object
        with standard sections (tags, summary, description, operationId, parameters, responses, security).

        @param DataObjectService The service containing the operation
        @param character The operation URI path
        @param MethodEnum The HTTP method for the operation
        @return JsonObject The operation object for the specified path and method
      */
    method protected JsonObject GetPathJson (input poService as DataObjectService,
                                             input pUri     as character,
                                             input pMethod  as MethodEnum):
        define variable pathJson      as JsonObject no-undo.
        define variable uriJson       as JsonObject no-undo.
        define variable path          as character  no-undo.
        define variable svcName       as character  no-undo.
        define variable operationJson as JsonObject no-undo.

        assign svcName = poService:Name.
        if svcName eq DataObjectService:ROOT_SERVICE_NAME then
            assign svcName = DataObjectService:ROOT_SERVICE_URI.

        assign
            pathJson = cast(this-object:Value, JsonObject):GetJsonObject('paths':u)
            path     = left-trim(svcName + '/':u + left-trim(pUri, '/':u), '/':u)
            path     = '/':u + path
            .

        if pathJson:Has(path) then
            assign uriJson = pathJson:GetJsonObject(path).
        else
        do:
            assign uriJson = new JsonObject().
            pathJson:Add(path, uriJson).
        end.

        // If the method already exists, remove it as WriteOperation will recreate it
        if uriJson:Has(lc(string(pMethod))) then
            uriJson:Remove(lc(string(pMethod))).

        assign operationJson = new JsonObject().
        uriJson:Add(lc(string(pMethod)), operationJson).

        operationJson:Add('tags':u,        new JsonArray()).
        operationJson:Add('summary':u,     '':u).
        operationJson:Add('description':u, '':u).
        operationJson:Add('operationId':u, '':u).
        operationJson:Add('parameters':u,  new JsonArray()).
        operationJson:Add('responses':u,   new JsonObject()).
        operationJson:Add('security':u,    new JsonArray()).

        return operationJson.
    end method. // GetPathJson

    /**
        Creates a headers object for an operation's response.
        Generates schema definitions for all HTTP headers defined in the operation.

        @param MappedOperation The operation containing header definitions
        @return JsonObject Headers object with schema definitions, or unknown if no headers
      */
    method protected JsonObject WriteHeaders (input poData as MappedOperation):
        define variable jsonHeaders as JsonObject no-undo.
        define variable hdrData     as JsonObject no-undo.
        {&_proparse_ prolint-nowarn(varusage)}
        define variable headers as HttpHeader extent no-undo.
        define variable loop    as integer    no-undo.
        define variable cnt     as integer    no-undo.

        assign cnt = poData:Headers:GetAll(headers).
        if cnt eq 0 then
            return jsonHeaders.

        assign
            jsonHeaders = new JsonObject()
            hdrData     = new JsonObject()
            .
        hdrData:Add('description':u, '':u).
        hdrData:Add('type':u,        'string':u).

        do loop = 1 to cnt:
            jsonHeaders:Add(headers[loop]:Name, hdrData).
        end.

        return jsonHeaders.
    end method. // WriteHeaders

    method override protected void WriteOperation (input poService as DataObjectService,
                                                   input poData    as MappedOperation):
        define variable operJson       as JsonObject         no-undo.
        define variable jsonData       as JsonObject         no-undo.
        define variable childObj       as JsonObject         no-undo.
        define variable schemaJson     as JsonObject         no-undo.
        define variable schemaChild    as JsonObject         no-undo.
        define variable jsonSchema     as JsonObject         no-undo.
        define variable responseSchema as JsonObject         no-undo. // responses.NNN.content.[type].schema — set once, reused by all loops
        define variable requestSchema  as JsonObject         no-undo. // requestBody.content.[type].schema — set once, reused by all loops
        define variable iter           as IIterator          no-undo.
        define variable opParam        as OperationParameter no-undo.
        define variable paramJson      as JsonArray          no-undo.
        define variable loop           as integer            no-undo.
        define variable cnt            as integer            no-undo.
        define variable operSchema     as handle             no-undo.
        define variable fldType        as character          no-undo.
        define variable fldFormat      as character          no-undo.
        define variable cTargetName    as character          no-undo.
        define variable cOperationID   as character          no-undo.

        // Check authorization before writing operation
        if not this-object:IsOperationAuthorized(poData) then
            return.

        // Obtain the operation (service+method) JSON object
        assign operJson = this-object:GetPathJson(poService, poData:ServiceURI, poData:Method).

        // Set summary - use name if available, otherwise use description (truncated to 80 chars)
        if poData:Name gt '':u then
            operJson:Set('summary':u, poData:Name).
        else if poData:Description gt '':u then
        do:
            if length(poData:Description) le 80 then
                operJson:Set('summary':u, poData:Description).
            else
                operJson:Set('summary':u, substring(poData:Description, 1, 77) + '...':u).
        end.
        else
            operJson:Set('summary':u, '':u).

        // The operationId uses information about the target type, name, and function for uniqueness while keeping
        // the identifier as short as possible and hiding internal implementation details. This approach is intended
        // to support common patterns (eg. Progress Data Objects) and while being compatible with external tooling
        // (e.g., FastMCP 60-character limit), and avoids revealing many architectural details about the application.
        if num-entries(poData:TargetName, '/':u) gt 0 then
            assign cTargetName = entry(num-entries(poData:TargetName, '/':u), poData:TargetName, '/':u).
        else
            assign cTargetName = poData:TargetName.

        case poData:TargetType:
            when string(TargetTypeEnum:File) then
            do: // eg. "<service>_file_<filename>"
                // Strip any path separators from the target name (e.g., backslashes on Windows)
                assign
                    cTargetName = replace(cTargetName, StringConstant:BACKSLASH, '_':u)
                    cTargetName = replace(cTargetName, '/':u, '_':u)
                    .
                assign cOperationID = substitute('&1_&2_&3':u, poService:Name, lc(poData:TargetType), cTargetName).
            end.
            when string(TargetTypeEnum:Void) then
            do: // eg. "<service>_void_<statuscode>"
                assign cOperationID = substitute('&1_&2_&3':u, poService:Name, lc(poData:TargetType), poData:StatusCode).
            end.
            when string(TargetTypeEnum:Procedure) then
            do: // eg. "<service>_<procedure>_<int_proc>" without any procedure file extension
                if cTargetName matches '*.p':u then
                    assign cTargetName = substring(cTargetName, 1, length(cTargetName) - 2).
                assign cOperationID = substitute('&1_&2_&3':u, poService:Name, cTargetName, poData:TargetFunction).
            end.
            when string(TargetTypeEnum:Class) or
            when string(TargetTypeEnum:Self) then
            do: // eg. "<service>_<class>_<method>" where class name is shortened using 0C format (CamelCase capitals only)
                assign cOperationID = substitute('&1_&2_&3':u, poService:Name, TokenResolver:ResolveName('0C':u, cTargetName), poData:TargetFunction).
            end.
            otherwise
                assign cOperationID = substitute('&1_&2_3':u, poService:Name, cTargetName, poData:TargetFunction).
        end case.

        // Sanitize operationId to ensure compatibility with code generators and tooling
        assign cOperationID = this-object:ScrubPunctuation(cOperationID).
        operJson:Set('operationId':u, cOperationID).

        operJson:GetJsonArray('tags':u):Add(poService:Name). // Add a tag with the service name.

        // Add security requirements based on operation's AccessControl (roles)
        this-object:WriteOperationSecurity(operJson, poData).

        // Set operation description if available
        if poData:Description gt '':u then
            operJson:Set('description':u, poData:Description).
        else
            // Provide a default description based on the target type and function.
            // Purposely vague to not reveal architectural decisions and code names!
            case poData:TargetType:
                when string(TargetTypeEnum:File) then
                    operJson:Set('description':u, substitute('Returns a specified file':u, poData:TargetName)).
                when string(TargetTypeEnum:Procedure) then
                    operJson:Set('description':u, substitute('Invokes &1 in called procedure':u, poData:TargetFunction)).
                when string(TargetTypeEnum:Class) then
                    operJson:Set('description':u, substitute('Invokes &1 in called OOABL class':u, poData:TargetFunction)).
                when string(TargetTypeEnum:Void) then
                    operJson:Set('description':u, substitute('Returns only a status code':u)).
                otherwise // eg. Self (the DOH class itself)
                    operJson:Set('description':u, substitute('Invokes &1 in the service':u, poData:TargetFunction)).
            end case.

        // responses
        assign
            childObj   = new JsonObject()
            schemaJson = new JsonObject()
            .

        operJson:GetJsonObject('responses':u):Add(string(poData:StatusCode, '999':u), childObj).

        if poData:EntityDescription gt '':u then
            childObj:Add('description':u, poData:EntityDescription).
        else
            childObj:Add('description':u, substitute('&1 &2 operation for service &3 v&4':u,
                                                     string(poData:Method),
                                                     poData:ServiceURI,
                                                     poService:Name,
                                                     string(poService:Version))).

        if poData:Headers:Size gt 0 then
            childObj:Add('headers':u, this-object:WriteHeaders(poData)).

        if poData:Name eq 'dataservice.catalog' then
        do:
            childObj:Add('content':u, new JsonObject()).
            childObj:GetJsonObject('content':u):Add(poData:ContentType, new JsonObject()).
            childObj:GetJsonObject('content':u):GetJsonObject(poData:ContentType):Add('schema':u, schemaJson).
            // Requires a cdo.json to be deployed 'next to' this openapi.json document
            schemaJson:Add('$ref':u, 'cdo.json#/components/schemas/dataServiceCatalog').
        end.
        else
            schemaJson:Add('type':u,   'object':u).

        /**
         * Vars responseSchema and requestSchema are the authoritative references to this
         * operation's response body schema and request body schema, respectively.
         * Each is set the first time any loop creates that schema and then used directly
         * by all subsequent loops once set.
         *
         * Note: schemaJson is used only for the inline schema of individual query/path/header/
         * cookie parameter entries, which are created and consumed within a single iteration.
         *
         * The loops always run in this order:
         *
         *   1. RETURNLOOP — runs once before any parameters are processed.
         *      Only handles the ioMode:RETURN argument (stored in poData:ReturnValue,
         *      not in the Parameters list). Sets responseSchema when it creates the
         *      response body.
         *
         *   2. For each parameter, in the order they appear in the mapping:
         *      a. INPUTLOOP  — writes query/path/header/cookie entries and request body
         *                      fields or body. Sets requestSchema on the first FIELD or
         *                      BODY input.
         *      b. OUTPUTLOOP — writes response body fields or body. Sets responseSchema
         *                      on the first FIELD or BODY output if RETURNLOOP did not.
         *      These two alternate per parameter; INPUTLOOP does not finish for all
         *      parameters before OUTPUTLOOP starts.
         */

        // if we use the return value, write that
        if valid-object(poData:ReturnValue) then
            assign cnt = extent(poData:ReturnValue:OutputElement).
        else
            assign cnt = 0. // Explicit: no ReturnValue means nothing for RETURNLOOP to process

        // RETURNLOOP: Processes the ABL function return value (ioMode:RETURN).
        // Registered via MappedOperation:ReturnValue rather than the Parameters list.
        // Sets responseSchema when it creates the response body schema.
        if cnt gt 0 then
        RETURNLOOP:
        do loop = 1 to cnt:
            // Use the safe navigation operator to check if any portion of this object chain is not valid.
            if not valid-object(poData?:ReturnValue?:OutputElement[loop]?:ElementType) then next RETURNLOOP.

            assign jsonData = operJson:GetJsonObject('responses':u):GetJsonObject(string(poData:StatusCode, '999':u)).

            case poData:ReturnValue:OutputElement[loop]:ElementType:
                when ElementTypeEnum:Field then
                do:
                    if not valid-object(responseSchema) then
                    do:
                        // Only create the response schema once, on the first FIELD or BODY output. All subsequent outputs reuse this schema.
                        assign responseSchema = new JsonObject().
                        jsonData:Add('content':u, new JsonObject()).
                        jsonData:GetJsonObject('content':u):Add(poData:ContentType, new JsonObject()).
                        jsonData:GetJsonObject('content':u):GetJsonObject(poData:ContentType):Add('schema':u, responseSchema).
                        responseSchema:Add('type':u, 'object':u).
                        responseSchema:Add('description':u, 'Body containing multiple individual fields':u).
                        responseSchema:Add('properties':u, new JsonObject()).
                    end.

                    // Write the RETURN FIELD property into the response schema.
                    this-object:AddPropertyWithSchema(poService,
                                                      responseSchema:GetJsonObject('properties':u),
                                                      poData:ReturnValue:OutputElement[loop]:ElementName,
                                                      poData:ReturnValue:ABLName,
                                                      poData:ReturnValue:ABLType).

                    if poData:ReturnValue:Description gt '':u then
                    do:
                        assign schemaChild = responseSchema:GetJsonObject('properties':u)
                                                           :GetJsonObject(poData:ReturnValue:OutputElement[loop]:ElementName).
                        if not schemaChild:Has('description':u) then
                            schemaChild:Add('description':u, poData:ReturnValue:Description).
                    end.
                end.

                when ElementTypeEnum:Body then
                do:
                    if not valid-object(responseSchema) then
                    do:
                        // Only create the response schema once, on the first FIELD or BODY output. All subsequent outputs reuse this schema.
                        assign responseSchema = new JsonObject().
                        jsonData:Add('content':u, new JsonObject()).
                        jsonData:GetJsonObject('content':u):Add(poData:ContentType, new JsonObject()).
                        jsonData:GetJsonObject('content':u):GetJsonObject(poData:ContentType):Add('schema':u, responseSchema).
                    end.

                    // For per-operation schemas, use inline; for service schemas, use a reference
                    assign operSchema = poData:GetSchema(poData:ReturnValue:ABLName).
                    if valid-handle(operSchema) then
                    do:
                        assign schemaChild = new JsonObject().

                        responseSchema:Add('type':u, 'object':u).
                        responseSchema:Add('additionalProperties':u, false).
                        responseSchema:Add('properties', schemaChild).

                        case operSchema:type:
                            when 'dataset':u then
                                schemaChild:Add(operSchema:serialize-name, this-object:WriteDataset(operSchema)).
                            when 'buffer':u then
                                schemaChild:Add(operSchema:serialize-name, this-object:WriteTable(operSchema)).
                            when 'table':u then
                                schemaChild:Add(operSchema:serialize-name, this-object:WriteTable(operSchema:default-buffer-handle)).
                        end case.
                    end.
                    else
                    do:
                        // Look for service schema if a data schema handle was not found
                        assign operSchema = poService:GetSchema(poData:ReturnValue:ABLName).

                        if valid-handle(operSchema) then
                            responseSchema:Add('$ref':u, '#/components/schemas/':u + operSchema:serialize-name).
                        else
                        do:
                            // Check if this is a JSON Schema stored in the catalog
                            assign jsonSchema = this-object:GetJsonSchema(poService, poData:ReturnValue:ABLName).
                            if valid-object(jsonSchema) then
                            do:
                                // For JSON schemas, copy the type
                                responseSchema:Add('type':u, jsonSchema:GetCharacter('type':u)).

                                if jsonSchema:Has('description':u) then
                                    responseSchema:Add('description':u, jsonSchema:GetCharacter('description':u)).
                                if jsonSchema:Has('items':u) then
                                    responseSchema:Add('items':u, cast(jsonSchema:GetJsonObject('items':u):Clone(), JsonObject)).
                                if jsonSchema:Has('properties':u) then
                                    responseSchema:Add('properties':u, cast(jsonSchema:GetJsonObject('properties':u):Clone(), JsonObject)).
                            end.
                            else
                                responseSchema:Add('type':u, 'object':u).
                        end.
                    end.
                end.

                otherwise
                    next RETURNLOOP.
            end case.
        end. // return value

        // Per-parameter loop: iterates all OperationParameters in declaration order.
        // For each parameter, INPUTLOOP runs first (inputs), then OUTPUTLOOP (outputs).
        // Parameters with ioMode:RETURN are stored in ReturnValue (handled above), not here.
        assign
            iter      = poData:Parameters:Iterator()
            paramJson = operJson:GetJsonArray('parameters':u)
            .
        do while iter:HasNext():
            assign opParam = cast(iter:Next(), OperationParameter).

            // INPUTLOOP: Processes each InputElement of the current parameter.
            // Writes QUERY/PATH/HEADER/COOKIE params to the parameters array, and
            // FIELD/BODY inputs to requestBody. Sets requestSchema on the first FIELD
            // or BODY input; schemaJson is used only for individual parameter schemas.
            // we only care about inputs here
            assign cnt = extent(opParam:InputElement).
            INPUTLOOP:
            do loop = 1 to cnt:
                // Use the safe navigation operator to check if any portion of this object chain is not valid.
                if not valid-object(opParam?:InputElement[loop]?:ElementType) then next INPUTLOOP.

                // REQUIRED. The location of the parameter. Possible values are "query", "header", "path" or "cookie".
                case opParam:InputElement[loop]:ElementType:
                    when ElementTypeEnum:Query  or
                    when ElementTypeEnum:Header or
                    when ElementTypeEnum:Cookie or
                    when ElementTypeEnum:Path then
                    do:
                        assign
                            childObj   = new JsonObject()
                            schemaJson = new JsonObject()
                            fldType    = this-object:FieldInfo(opParam:ABLType, output fldFormat)
                            .

                        paramJson:Add(childObj).
                        childObj:Add('in':u,        lc(string(opParam:InputElement[loop]:ElementType))).
                        childObj:Add('name':u,      opParam:InputElement[loop]:ElementName).
                        childObj:Add('required':u,  (opParam:InputElement[loop]:ElementType eq ElementTypeEnum:Path)).
                        if opParam:Description gt '':u then
                            childObj:Add('description':u, opParam:Description).
                        else
                            childObj:Add('description':u, substitute('&1 parameter &2':u, string(opParam:InputElement[loop]:ElementType), opParam:InputElement[loop]:ElementName)).
                        childObj:Add('schema':u, schemaJson).
                        schemaJson:Add('type':u, fldType).
                        this-object:ApplyFieldFormat(schemaJson, fldFormat).
                    end. // Element: Query, Header, Path, Cookie

                    when ElementTypeEnum:Field then
                    do:
                        if not valid-object(requestSchema) then
                        do:
                            // Only create the request schema once, on the first FIELD or BODY output. All subsequent outputs reuse this schema.
                            assign
                                childObj      = new JsonObject()
                                requestSchema = new JsonObject()
                                .

                            operJson:Add('requestBody':u, childObj).
                            childObj:Add('description':u, substitute('Request body as &1':u, poData:ContentType)).
                            childObj:Add('content':u, new JsonObject()).
                            childObj:GetJsonObject('content':u):Add(poData:ContentType, new JsonObject()).
                            childObj:GetJsonObject('content':u):GetJsonObject(poData:ContentType):Add('schema':u, requestSchema).
                            requestSchema:Add('type':u, 'object':u).
                            requestSchema:Add('description':u, 'Body containing multiple individual fields':u).
                            requestSchema:Add('properties':u, new JsonObject()).
                        end.

                        // Append this field (with type and format) to the schema's properties by name.
                        // Use AddPropertyWithSchema to check for JSON Schema definitions by ablName.
                        this-object:AddPropertyWithSchema(poService,
                                                          requestSchema:GetJsonObject('properties':u),
                                                          opParam:InputElement[loop]:ElementName,
                                                          opParam:ABLName,
                                                          opParam:ABLType).

                        // Add description if available and not already in JSON Schema
                        if opParam:Description gt '':u then
                        do:
                            assign schemaChild = requestSchema:GetJsonObject('properties':u)
                                                              :GetJsonObject(opParam:InputElement[loop]:ElementName).
                            if not schemaChild:Has('description':u) then
                                schemaChild:Add('description':u, opParam:Description).
                        end.
                    end. // Element: Field

                    when ElementTypeEnum:Body then
                    do:
                        // Only create the request schema once, on the first FIELD or BODY output. All subsequent outputs reuse this schema.
                        assign
                            childObj      = new JsonObject()
                            requestSchema = new JsonObject()
                            .

                        operJson:Add('requestBody':u, childObj).
                        childObj:Add('description':u, if opParam:Description gt '':u then opParam:Description else opParam:ABLType).
                        childObj:Add('content':u, new JsonObject()).
                        childObj:GetJsonObject('content':u):Add(poData:ContentType, new JsonObject()).
                        childObj:GetJsonObject('content':u):GetJsonObject(poData:ContentType):Add('schema':u, requestSchema).

                        // For per-operation schemas, use inline; for service schemas, use a reference
                        assign operSchema = poData:GetSchema(opParam:ABLName).
                        if valid-handle(operSchema) then
                        do:
                            assign schemaChild = new JsonObject().
                            requestSchema:Add('type':u, 'object':u).
                            if opParam:Description gt '':u then
                                requestSchema:Add('description':u, opParam:Description).
                            else
                                requestSchema:Add('description':u, substitute('Request body parameter as &1':u, operSchema:type)).
                            requestSchema:Add('additionalProperties':u, false).
                            requestSchema:Add('properties', schemaChild).

                            case operSchema:type:
                                when 'dataset':u then
                                    schemaChild:Add(operSchema:serialize-name, this-object:WriteDataset(operSchema)).
                                when 'buffer':u then
                                    schemaChild:Add(operSchema:serialize-name, this-object:WriteTable(operSchema)).
                                when 'table':u then
                                    schemaChild:Add(operSchema:serialize-name, this-object:WriteTable(operSchema:default-buffer-handle)).
                            end case.
                        end.
                        else
                        do:
                            // Look for service schema if a per-operation schema was not found
                            assign operSchema = poService:GetSchema(opParam:ABLName).

                            if valid-handle(operSchema) then
                            do:
                                requestSchema:Add('$ref':u, '#/components/schemas/':u + operSchema:serialize-name).
                            end.
                            else
                            do:
                                // Check if this is a JSON Schema stored in the mapping information file
                                assign jsonSchema = this-object:GetJsonSchema(poService, opParam:ABLName).
                                if valid-object(jsonSchema) then
                                    // Use $ref to the schema (WriteAllJsonSchemas will write it)
                                    requestSchema:Add('$ref':u, '#/components/schemas/':u + opParam:ABLName).
                                else
                                    requestSchema:Add('type':u, 'object':u).
                            end.
                        end.
                    end. // Element: Body

                    otherwise
                        next INPUTLOOP. // Any other element type is unsupported for OpenAPI
                end case.
            end. // input loop

            // OUTPUTLOOP: Processes each OutputElement of the current parameter.
            // Writes FIELD outputs to responseSchema.properties, and BODY outputs to
            // responseSchema directly. Creates responseSchema on the first output if
            // RETURNLOOP did not already create it.
            assign cnt = extent(opParam:OutputElement).

            OUTPUTLOOP:
            do loop = 1 to cnt:
                // Use the safe navigation operator to check if any portion of this object chain is not valid.
                if not valid-object(opParam?:OutputElement[loop]?:ElementType) then next OUTPUTLOOP.

                assign jsonData = operJson:GetJsonObject('responses':u):GetJsonObject(string(poData:StatusCode, '999':u)).
                case opParam:OutputElement[loop]:ElementType:
                    when ElementTypeEnum:Field then
                    do:
                        if not valid-object(responseSchema) then
                        do:
                            // Only create the response schema once, on the first FIELD or BODY output. All subsequent outputs reuse this schema.
                            assign responseSchema = new JsonObject().
                            jsonData:Add('content':u, new JsonObject()).
                            jsonData:GetJsonObject('content':u):Add(poData:ContentType, new JsonObject()).
                            jsonData:GetJsonObject('content':u):GetJsonObject(poData:ContentType):Add('schema':u, responseSchema).
                            responseSchema:Add('type':u, 'object':u).
                            responseSchema:Add('description':u, 'Body containing multiple individual fields':u).
                            responseSchema:Add('properties':u, new JsonObject()).
                        end.

                        // Append this field (with type and format) to the schema's properties by name.
                        // Use AddPropertyWithSchema to check for JSON Schema definitions by ablName.
                        this-object:AddPropertyWithSchema(poService,
                                                          responseSchema:GetJsonObject('properties':u),
                                                          opParam:OutputElement[loop]:ElementName,
                                                          opParam:ABLName,
                                                          opParam:ABLType).

                        // Add description if available and not already in JSON Schema
                        if opParam:Description gt '':u then
                        do:
                            assign schemaChild = responseSchema:GetJsonObject('properties':u)
                                                               :GetJsonObject(opParam:OutputElement[loop]:ElementName).
                            if not schemaChild:Has('description':u) then
                                schemaChild:Add('description':u, opParam:Description).
                        end.
                    end. // Element: Field

                    when ElementTypeEnum:Body then
                    do:
                        if not valid-object(responseSchema) then
                        do:
                            // Only create the response schema once, on the first FIELD or BODY output. All subsequent outputs reuse this schema.
                            assign responseSchema = new JsonObject().
                            jsonData:Add('content':u, new JsonObject()).
                            jsonData:GetJsonObject('content':u):Add(poData:ContentType, new JsonObject()).
                            jsonData:GetJsonObject('content':u):GetJsonObject(poData:ContentType):Add('schema':u, responseSchema).
                        end.

                        // For per-operation schemas, use inline; for service schemas, use a reference
                        assign operSchema = poData:GetSchema(opParam:ABLName).
                        if valid-handle(operSchema) then
                        do:
                            assign schemaChild = new JsonObject().
                            responseSchema:Add('type':u, 'object':u).
                            if opParam:Description gt '':u then
                                responseSchema:Add('description':u, opParam:Description).
                            else
                                responseSchema:Add('description':u, substitute('Response body parameter as &1':u, operSchema:type)).
                            responseSchema:Add('additionalProperties':u, false).
                            responseSchema:Add('properties', schemaChild).

                            case operSchema:type:
                                when 'dataset':u then
                                    schemaChild:Add(operSchema:serialize-name, this-object:WriteDataset(operSchema)).
                                when 'buffer':u then
                                    schemaChild:Add(operSchema:serialize-name, this-object:WriteTable(operSchema)).
                                when 'table':u then
                                    schemaChild:Add(operSchema:serialize-name, this-object:WriteTable(operSchema:default-buffer-handle)).
                            end case.
                        end.
                        else
                        do:
                            // Look for service schema if a data schema handle was not found
                            assign operSchema = poService:GetSchema(opParam:ABLName).

                            if valid-handle(operSchema) then
                            do:
                                responseSchema:Add('$ref':u, '#/components/schemas/':u + operSchema:serialize-name).
                            end.
                            else
                            do:
                                // Check if this is a JSON Schema stored in the mapping information file
                                assign jsonSchema = this-object:GetJsonSchema(poService, opParam:ABLName).
                                if valid-object(jsonSchema) then
                                    // Use $ref to the schema (WriteAllJsonSchemas will write it)
                                    responseSchema:Add('$ref':u, '#/components/schemas/':u + opParam:ABLName).
                                else
                                do:
                                    responseSchema:Add('type':u, 'object':u).
                                    if opParam:Description gt '':u then
                                        responseSchema:Add('description':u, opParam:Description).
                                end.
                            end.
                        end.
                    end. // Element: Body

                    otherwise
                        next OUTPUTLOOP. // Any other element type is unsupported for OpenAPI
                end case.
            end. // output loop
        end.
    end method. // WriteOperation

    /**
        Creates a JSON Schema representation of an ABL dataset.
        Produces a nested object structure with properties for each buffer in the dataset.

        @param handle A valid dataset handle
        @return JsonObject The JSON Schema object representing the dataset structure
      */
    method protected JsonObject WriteDataset (input poDataset as handle):
        define variable loop        as integer    no-undo.
        define variable cnt         as integer    no-undo.
        define variable childData   as JsonObject no-undo.
        define variable datasetJson as JsonObject no-undo.
        define variable bufferHdl   as handle     no-undo.
        define variable propsJson   as JsonObject no-undo.

        if not valid-handle(poDataset) then
            return datasetJson.

        assign
            datasetJson = new JsonObject()
            propsJson   = new JsonObject()
            childData   = new JsonObject()
            cnt         = poDataset:num-buffers
            .

        datasetJson:Add('type':u, 'object':u).
        datasetJson:Add('additionalProperties':u, false).
        datasetJson:Add('properties':u, propsJson).
        propsJson:Add(poDataset:serialize-name, childData).
        childData:Add('type':u, 'object':u).
        childData:Add('additionalProperties':u, false).

        assign propsJson = new JsonObject().
        childData:Add('properties':u, propsJson).

        do loop = 1 to cnt:
            assign bufferHdl = poDataset:get-buffer-handle(loop).
            propsJson:Add(bufferHdl:serialize-name, this-object:WriteTable(bufferHdl)).
        end.

        return datasetJson.
    end method. // WriteDataset

    /**
        Creates a JSON Schema for a single ABL field.
        Includes type, title, description, nullable, required, and format properties.

        @param handle A valid buffer-field handle
        @param character Comma-delimited list of unique field names for required flag
        @return JsonObject The JSON Schema object for the field
      */
    method protected JsonObject CreateFieldSchema (input pFieldHandle  as handle,
                                                   input pRequiredFlds as character):
        define variable fldJson as JsonObject no-undo.
        define variable fldType as character no-undo.
        define variable fldFormat as character no-undo.

        assign
            fldJson = new JsonObject()
            fldType = this-object:FieldInfo(pFieldHandle:data-type, output fldFormat)
            .

        fldJson:Add('title':u, pFieldHandle:label).
        if pFieldHandle:help gt '':u then
            fldJson:Add('description':u, pFieldHandle:help).
        else
            fldJson:Add('description':u, pFieldHandle:label).
        fldJson:Add('type':u, fldType).

        this-object:AddNullableProperty(fldJson).
        this-object:MarkRequiredField(fldJson, pFieldHandle:serialize-name, pRequiredFlds).
        this-object:ApplyFieldFormat(fldJson, fldFormat).

        return fldJson.
    end method. // CreateFieldSchema

    /**
        Creates a JSON Schema for an ABL array field (extent).
        Produces an array type with items schema including maxItems based on extent size.

        @param handle A valid buffer-field handle with extent
        @param character Comma-delimited list of unique field names for required flag
        @return JsonObject The JSON Schema object for the array field
      */
    method protected JsonObject CreateArrayFieldSchema (input pFieldHandle  as handle,
                                                        input pRequiredFlds as character):
        define variable fldJson as JsonObject no-undo.
        define variable childObj as JsonObject no-undo.
        define variable fldType as character no-undo.
        define variable fldFormat as character no-undo.

        assign
            fldJson  = new JsonObject()
            childObj = new JsonObject()
            fldType  = this-object:FieldInfo(pFieldHandle:data-type, output fldFormat)
            .

        fldJson:Add('type':u, 'array':u).
        fldJson:Add('title':u, pFieldHandle:label).
        if pFieldHandle:help gt '':u then
            fldJson:Add('description':u, pFieldHandle:help).
        else
            fldJson:Add('description':u, pFieldHandle:label).
        fldJson:Add('maxItems':u, pFieldHandle:extent).
        fldJson:Add('items':u, childObj).

        childObj:Add('type':u, fldType).
        this-object:AddNullableProperty(childObj).
        this-object:MarkRequiredField(childObj, pFieldHandle:serialize-name, pRequiredFlds).
        this-object:ApplyFieldFormat(childObj, fldFormat).
        this-object:WriteDefaultFieldValue(pFieldHandle, childObj).

        return fldJson.
    end method. // CreateArrayFieldSchema

    /**
        Creates a JSON Schema representation of an ABL temp-table or buffer.
        Produces an array type with items containing all non-hidden fields as properties.
        Identifies required fields based on unique indexes.

        @param handle A valid buffer handle
        @return JsonObject The JSON Schema object representing the table structure
      */
    method protected JsonObject WriteTable (input pTable as handle):
        define variable loop        as integer    no-undo.
        define variable cnt         as integer    no-undo.
        define variable idx         as integer    no-undo.
        define variable tableJson   as JsonObject no-undo.
        define variable fldJson     as JsonObject no-undo.
        define variable itemsJson   as JsonObject no-undo.
        define variable bufferFld   as handle     no-undo.
        define variable propsJson   as JsonObject no-undo.
        define variable uniqueFld   as character  no-undo.
        define variable requiredFld as character  no-undo.
        define variable idxInfo     as character  no-undo.
        define variable delim       as character  no-undo initial "".

        if not valid-handle(pTable) then
            return tableJson.

        /**
         * Determine unique fields by tracking those that are in a unique index.
         * index-information(n) returns a comma-delimited string per index:
         *   entry(1) = index name
         *   entry(2) = "1" if unique, "0" if not
         *   entry(3) = "1" if primary, "0" if not
         *   entry(4) = "1" if word-index, "0" if not
         *   entry(5), entry(7), ... = ABL field names in the index
         *   entry(6), entry(8), ... = ascending/descending flag per field
         * Returns ? when there are no more indexes to enumerate.
         */
        assign
            idx     = 1
            idxInfo = pTable:index-information(idx)
            .

        do while not idxInfo eq ?:
            if entry(2, idxInfo) eq '1':u then  // unique index
            do:
                // index fields
                assign cnt = num-entries(idxInfo).
                IDXLOOP:
                do loop = 5 to cnt by 2:
                    if entry(loop, idxInfo) eq '':u then
                        next IDXLOOP.
                    assign
                        uniqueFld = substitute("&1&2&3",uniqueFld, delim, entry(loop, idxInfo))
                        delim     = ',':u
                        .
                end.
            end.

            assign
                idx     = idx + 1
                idxInfo = pTable:index-information(idx)
                .
        end.

        assign
            tableJson = new JsonObject()
            itemsJson = new JsonObject()
            propsJson = new JsonObject()
            cnt       = pTable:num-fields
            .
        tableJson:Add('type':u, 'array':u).
        tableJson:Add('items':u, itemsJson).
        itemsJson:Add('additionalProperties':u, false).
        itemsJson:Add('properties':u, propsJson).

        BUFFLOOP:
        do loop = 1 to cnt:
            assign bufferFld = pTable:buffer-field(loop).

            // Not visible to the outside world
            if bufferFld:serialize-hidden then
                next BUFFLOOP.

            // Track required fields by their serialized name, if available.
            // This is based on the actual field name being in the list of unique fields.
            if lookup(bufferFld:name, uniqueFld, ",") gt 0 then
                assign requiredFld = trim(substitute("&1,&2", requiredFld, bufferFld:serialize-name), ",").

            // Create the field schema using helper methods
            if bufferFld:extent gt 0 then
                assign fldJson = this-object:CreateArrayFieldSchema(bufferFld, requiredFld).
            else
            do:
                assign fldJson = this-object:CreateFieldSchema(bufferFld, requiredFld).
                this-object:WriteDefaultFieldValue(bufferFld, fldJson).
            end.

            propsJson:Add(bufferFld:serialize-name, fldJson).
            delete object bufferFld.
        end. // num-fields

        // Allow subclasses to apply required field marking at the items level.
        this-object:MarkRequiredFields(itemsJson, requiredFld).

        return tableJson.
    end method. // WriteTable

    /* Writes the correctly-typed default value for a field

       @param handle A valid buffer-field handle
       @param JsonObject A valid JSON object representing the field */
    method protected void WriteDefaultFieldValue (input pField as handle,
                                                  input pJson  as JsonObject):
        if not valid-handle(pField)
            or not valid-object(pJson)
            then
            return.

        if pField:default-value eq ? then
            pJson:AddNull('default':u).
        else
            case pField:data-type:
                when 'date':u then
                    // date-fullyear "-" date-month "-" date-mday
                    pJson:Add('default':u, substitute('&1-&2-&3':u,
                        string(year(pField:default-value), '9999':u),
                        string(month(pField:default-value), '99':u),
                        string(day(pField:default-value), '99':u))).

                when 'datetime':u or
                when 'datetime-tz':u then
                    pJson:Add('default':u, iso-date(pField:default-value)).

                when 'integer':u or
                when 'int64':u then
                    pJson:Add('default':u, int64(pField:default-value)).

                when 'decimal':u then
                    pJson:Add('default':u, decimal(pField:default-value)).

                when 'logical':u then
                    pJson:Add('default':u, logical(pField:default-value)).

                when 'blob':u or
                when 'raw':u then
                    pJson:AddNull('default':u).

                otherwise
                    pJson:Add('default':u, string(pField:default-value)).
            end case.
    end method. // WriteDefaultFieldValue

    /**
        Sanitizes a character value to ensure compatibility with code generators and external tooling.
        Replaces problematic characters (dots, slashes, backslashes, spaces) with underscores.
        Ensures the resulting identifier is safe for use as a method/function name in most languages.

        @param character The raw character value to sanitize
        @return character The scrubbed character value with safe characters only
      */
    method protected character ScrubPunctuation (input pcInputString as character):
        var character cScrubbed.

        assign cScrubbed = pcInputString.

        // Replace dots with underscores
        assign cScrubbed = replace(cScrubbed, '.':u, '_':u).

        // Replace any remaining path separators
        assign
            cScrubbed = replace(cScrubbed, '/':u, '_':u)
            cScrubbed = replace(cScrubbed, StringConstant:BACKSLASH, '_':u)
            .

        // Replace spaces and other problematic characters
        assign
            cScrubbed = replace(cScrubbed, ' ':u, '_':u)
            cScrubbed = replace(cScrubbed, '-':u, '_':u)
            .

        return cScrubbed.
    end method. // ScrubPunctuation

    /**
        Converts ABL data type to JSON Schema type and format.
        Maps ABL types to OpenAPI/JSON Schema equivalents with appropriate format hints.

        @param character ABL data type name
        @param character OUTPUT format string (e.g., 'date', 'date-time', 'int32', 'int64', 'binary')
        @return character JSON Schema type ('string', 'integer', 'number', 'boolean', 'object', 'array')
      */
    method protected character FieldInfo (input  pAblType as character,
                                          output pFormat  as character):
        define variable fldType as character no-undo.

        // Handle Progress.Json.ObjectModel.* classes as a special case.
        if pAblType matches '*Progress.Json.ObjectModel.*':u then do:
            if pAblType matches '*Progress.Json.ObjectModel.JsonArray*':u then
                // Explicitly the JsonArray type
                assign
                    fldType = 'array':u
                    pFormat = '':u
                    .
            else
                // Handles Progress.Json.ObjectModel.JsonObject or unknown ObjectModel types
                assign
                    fldType = 'object':u
                    pFormat = '':u
                    .
            return fldType.
        end.

        case pAblType:
            when 'date':u then
                assign
                    fldType = 'string':u
                    pFormat = 'date':u
                    .
            when 'datetime':u or
            when 'datetime-tz':u then
                assign
                    fldType = 'string':u
                    pFormat = 'date-time':u
                    .
            when 'character':u or
            when 'clob':u or
            when 'longchar' then
                assign
                    fldType = 'string':u
                    pFormat = '':u
                    .
            when 'integer':u then
                assign
                    fldType = 'integer':u
                    pFormat = 'int32':u
                    .
            when 'int64':u then
                assign
                    fldType = 'integer':u
                    pFormat = 'int64':u
                    .
            when 'decimal':u then
                assign
                    fldType = 'number':u
                    pFormat = '':u
                    .
            when 'logical':u then
                assign
                    fldType = 'boolean':u
                    pFormat = '':u
                    .
            when 'blob':u or
            when 'raw':u then
                assign
                    fldType = 'string':u
                    pFormat = 'binary':u
                    .
            otherwise
                // For any CLASS types that are not Progress.Json.ObjectModel.*
                // (e.g., Progress.Lang.Object) these are serialized via the
                // JsonConverter.AddToObject, which calls ToString() for unknown
                // types. The wire format is therefore a string in JSON.
                assign
                    fldType = 'string':u
                    pFormat = '':u
                    .
        end case.

        return fldType.
    end method. // FieldInfo

    /**
        Writes a schema definition to the components/schemas section.
        Handles datasets, buffers, and temp-tables by generating appropriate JSON Schema.
        Note: For per-operation schemas, inline definitions are used within operations.
        Service-level schemas use references via $ref to this components/schemas section.
        This method is typically called during service initialization to populate shared schemas.

        @param DataObjectService The service containing the schema
        @param handle A valid dataset, buffer, or table handle
      */
    method override protected void WriteSchema (input poService as DataObjectService,
                                                input poData    as handle):
        define variable schemaRoot as JsonObject no-undo.
        define variable schemaData as JsonObject no-undo.

        if not valid-handle(poData) then
            return.

        assign schemaRoot = cast(this-object:Value, JsonObject)
                                :GetJsonObject('components':u)
                                :GetJsonObject('schemas':u).

        case poData:type:
            when 'dataset':u then
                assign schemaData = this-object:WriteDataset(poData).
            when 'buffer':u then
                assign schemaData = this-object:WriteTable(poData).
            when 'table':u then
                assign schemaData = this-object:WriteTable(poData:default-buffer-handle).
        end case.

        if not valid-object(schemaData) then
            return.

        if schemaRoot:Has(poData:serialize-name) then
            schemaRoot:Set(poData:serialize-name, schemaData).
        else
            schemaRoot:Add(poData:serialize-name, schemaData).
    end method. // WriteSchema

    /**
        Adds or updates a tag in the OpenAPI document's tags array.
        Tags are used to group operations and provide additional metadata.

        @param character Tag name (must be unique)
        @param character Tag description
        @param JsonObject Optional external documentation object
      */
    method protected void WriteTag (input pName        as character,
                                    input pDescription as character,
                                    input pExtDoc      as JsonObject):
        define variable tagArray  as JsonArray  no-undo.
        define variable tagData   as JsonObject no-undo.
        define variable loop      as integer    no-undo.
        define variable cnt       as integer    no-undo.
        define variable tagExists as logical    no-undo.

        assign
            tagArray  = cast(this-object:Value, JsonObject):GetJsonArray('tags':u)
            cnt       = tagArray:Length
            tagExists = no
            .

        do loop = 1 to cnt while not tagExists:
            assign
                tagData   = tagArray:GetJsonObject(loop)
                tagExists = tagData:GetCharacter('name':u) eq pName
                .
        end.

        if tagExists then
        do:
            tagData:Set('description':u, pDescription).
            if valid-object(pExtDoc) then
                tagData:Set('externalDocs':u, pExtDoc).
        end.
        else
        do:
            assign tagData = new JsonObject().
            tagArray:Add(tagData).
            tagData:Add('name':u, pName).
            tagData:Add('description':u, pDescription).
            if valid-object(pExtDoc) then
                tagData:Add('externalDocs':u, pExtDoc).
        end.
    end method. // WriteTag

    /**
        Adds a property to a properties object, using JSON Schema if available.
        Matches schemas by ABL parameter name for consistency with Body element handling.

        @param DataObjectService The service containing potential JSON schemas
        @param JsonObject The properties object to add to
        @param character The property name (wire format/serialize-name) for JSON output
        @param character The ABL parameter name for schema lookup
        @param character The ABL data type for fallback
      */
    method protected void AddPropertyWithSchema (input poService   as DataObjectService,
                                                 input pPropsJson as JsonObject,
                                                 input pPropName  as character,
                                                 input pAblName   as character,
                                                 input pAblType   as character):
        define variable oJsonSchema as JsonObject no-undo.
        define variable oPropSchema as JsonObject no-undo.
        define variable hSchema     as handle     no-undo.

        // Check if there's a JSON Schema for this ABL parameter name
        assign oJsonSchema = this-object:GetJsonSchema(poService, pAblName).

        // Check if there is defined schema (DATASET or TEMP-TABLE)
        if (pAblName gt '':u) eq true then
            assign hSchema = poService:GetSchema(pAblName).

        if valid-object(oJsonSchema) then
        do:
            // Add reference to schema in components/schemas section
            assign oPropSchema = new JsonObject().
            oPropSchema:Add('$ref':u, '#/components/schemas/':u + pAblName).
            pPropsJson:Add(pPropName, oPropSchema).
        end.
        else if valid-handle(hSchema) then
        do:
            // DATASET or TABLE mapped to a FIELD element — reference the registered component schema
            assign oPropSchema = new JsonObject().
            oPropSchema:Add('$ref':u, substitute('#/components/schemas/&1':u, hSchema:serialize-name)).
            pPropsJson:Add(pPropName, oPropSchema).
        end.
        else
        do:
            // Fall back to basic type from ABL type
            define variable fldFormat as character  no-undo.
            define variable fldType   as character  no-undo.
            define variable itemsJson as JsonObject no-undo.

            assign
                oPropSchema = new JsonObject()
                fldType     = this-object:FieldInfo(pAblType, output fldFormat)
                .
            oPropSchema:Add('type':u, fldType).

            // For array types, add items schema (generic object)
            if fldType eq 'array':u then
            do:
                assign itemsJson = new JsonObject().
                itemsJson:Add('type':u, 'object':u).
                oPropSchema:Add('items':u, itemsJson).
            end.

            if fldFormat gt '':u then
                oPropSchema:Add('format':u, fldFormat).
            pPropsJson:Add(pPropName, oPropSchema).
        end.
    end method. // AddPropertyWithSchema

    /**
        Writes a JSON Schema to the components/schemas section.

        @param DataObjectService The service containing the schema
        @param character The schema name
        @param JsonObject The JSON Schema definition
      */
    method protected void WriteJsonSchema (input poService as DataObjectService,
                                           input poSchemaName as character,
                                           input poSchema as JsonObject):
        define variable oSchemas as JsonObject no-undo.
        define variable oSvcJson as JsonObject no-undo.

        if not valid-object(poSchema) then
            return.

        assign oSvcJson = cast(this-object:Value, JsonObject).
        if not oSvcJson:Has('components':u) then
            return.

        assign oSchemas = oSvcJson:GetJsonObject('components':u):GetJsonObject('schemas':u).

        // Only add if not already present (avoid duplicates)
        if not oSchemas:Has(poSchemaName) then
            oSchemas:Add(poSchemaName, cast(poSchema:Clone(), JsonObject)).
    end method. // WriteJsonSchema

    /** Writes all JSON schemas from a service's map schemas to the components/schemas section.
        This ensures all defined schemas are available in the OpenAPI document, including those
        referenced by other schemas via $ref. Calls WriteJsonSchema for each schema to reuse
        the write logic.

        @param DataObjectService The service containing the JSON schemas
      */
    method protected void WriteAllJsonSchemas (input poService as DataObjectService):
        define variable cSchemaNames as character extent no-undo.
        define variable cSchemaName  as character no-undo.
        define variable oSchema      as JsonObject no-undo.
        define variable iLoop        as integer no-undo.
        define variable iCount       as integer no-undo.

        if not valid-object(poService) then
            return.

        if not valid-object(poService:JsonSchemas) then
            return.

        assign
            cSchemaNames = poService:JsonSchemas:GetNames()
            iCount       = extent(cSchemaNames)
            .

        // Write all JSON schemas to components/schemas using WriteJsonSchema
        do iLoop = 1 to iCount:
            assign
                cSchemaName = cSchemaNames[iLoop]
                oSchema     = poService:JsonSchemas:GetJsonObject(cSchemaName)
                .

            // WriteJsonSchema handles duplicate checking and cloning
            if valid-object(oSchema) then
                this-object:WriteJsonSchema(poService, cSchemaName, oSchema).
        end.
    end method. // WriteAllJsonSchemas

    /**
        Retrieves a JSON Schema definition from the service's map schemas.

        @param DataObjectService The service containing the map schemas
        @param character The schema name to retrieve
        @return JsonObject The JSON Schema definition, or unknown if not found
      */
    method protected JsonObject GetJsonSchema (input poService    as DataObjectService,
                                               input poSchemaName as character):
        define variable oSchemas as JsonObject no-undo.
        define variable oSchema as JsonObject no-undo.

        if not valid-object(poService) then
            return ?.
        if not valid-object(poService:JsonSchemas) then
            return ?.

        assign oSchemas = poService:JsonSchemas.

        if not oSchemas:Has(poSchemaName) then
            return ?.

        if not oSchemas:GetType(poSchemaName) eq JsonDataType:OBJECT then
            return ?.

        assign oSchema = oSchemas:GetJsonObject(poSchemaName).

        // Verify this is a JSON Schema by checking for 'type' property
        if oSchema:Has('type':u) then
            return oSchema.
        else
            return ?.
    end method. // GetJsonSchema

    /**
        Writes service metadata to the OpenAPI document.
        Updates the info section with service description and version, and creates
        a tag for grouping operations under this service.

        @param DataObjectService The service to write metadata for
      */
    method override protected void WriteService (input poData as DataObjectService):
        define variable infoJson as JsonObject no-undo.

        if not valid-object(poData) then
            return.

        assign infoJson = cast(this-object:Value, JsonObject):GetJsonObject('info':u).

        // Update the info section with the service description and version
        if poData:Description gt '':u then
            infoJson:Set('description':u, poData:Description).
        else
            infoJson:Set('description':u, substitute('API documentation for &1 v&2':u, poData:Name, string(poData:Version))).

        // Override document version with service version
        if valid-object(poData:Version) then
            infoJson:Set('version':u, string(poData:Version)).

        this-object:WriteTag(poData:Name, substitute('Service for &1 v&2',
                                                     trim(poData:Name, '/':u),
                                                     string(poData:Version)),
                                                     ?).

        // Write all JSON schemas defined for this service to components/schemas
        this-object:WriteAllJsonSchemas(poData).
    end method. // WriteService

    /**
       Writes a URI to the output

       @param URI The URI to write */
    method override protected void WriteURI (input poData as URI):
        define variable oServers as JsonArray  no-undo.
        define variable oServer  as JsonObject no-undo.

        if not valid-object(poData) then
            return.

        assign
            oServers = cast(this-object:Value, JsonObject):GetJsonArray('servers':u)
            oServer  = new JsonObject()
            .

        oServers:Add(oServer).
        oServer:Add('url':u, poData:ToString()).
        oServer:Add('description':u, 'Server configuration':u).
    end method. // WriteURI

    /**
        Gets the current user's Principal, with caching for performance.
        Called once during Open() to avoid repeated Import() calls.

        @return Principal The current user's Principal, or unknown if not authenticated
      */
    method protected Principal GetCurrentPrincipal ():
        define variable oCurrentUser as Principal no-undo.

        // Try to import from the session
        assign oCurrentUser = Principal:Import().
        if not valid-object(oCurrentUser) then
            assign oCurrentUser = Principal:Import(session:current-request-info).

        return oCurrentUser.
    end method. // GetCurrentPrincipal

    /**
        Checks if the current user is authorized to access an operation.
        If the operation has no ACL defined, it is considered accessible to all.
        If ACLs are defined, the user must have at least one of the required roles.
        Uses cached Principal for performance across multiple operation checks.

        @param MappedOperation The operation to check authorization for
        @return logical TRUE if the user is authorized or no ACLs are defined, FALSE otherwise
      */
    method protected logical IsOperationAuthorized (input poOperation as MappedOperation):
        define variable lAuthorized as logical no-undo.

        // If no ACLs are defined, operation is accessible to all.
        if extent(poOperation:AccessControl) eq ? then
        do:
            this-object:Logger:Trace(substitute('Operation "&1 &2" has no ACL - accessible to all',
                                                poOperation:Method,
                                                poOperation:ServiceURI)).
            return true.
        end.

        this-object:Logger:Trace(substitute('Checking authorization for operation "&1 &2" - requires one of roles ["&3"]',
                                 poOperation:Method,
                                 poOperation:ServiceURI,
                                 OpenEdge.Core.String:Join(poOperation:AccessControl, '","':u) )).

        // If no user is asserted and ACLs are required, deny access.
        if not valid-object(oCachedPrincipal) then
        do:
            this-object:Logger:Debug(substitute('Operation "&1 &2" excluded from OpenAPI doc: no user authenticated, requires roles ["&3"]',
                                                poOperation:Method,
                                                poOperation:ServiceURI,
                                                OpenEdge.Core.String:Join(poOperation:AccessControl, '","':u) )).
            return false.
        end.

        // Check if user has at least one of the required roles.
        assign lAuthorized = oCachedPrincipal:AuthorizeOne(poOperation:AccessControl).

        if lAuthorized then
            this-object:Logger:Debug(substitute('Operation "&1 &2" included in OpenAPI doc: user "&3" authorized with roles ["&4"]',
                                                poOperation:Method,
                                                poOperation:ServiceURI,
                                                (if valid-handle(oCachedPrincipal:Token) then oCachedPrincipal:Token:user-id else '?':u),
                                                (if valid-handle(oCachedPrincipal:Token) then oCachedPrincipal:Token:roles else '?':u) )).
        else
            this-object:Logger:Debug(substitute('Operation "&1 &2" excluded from OpenAPI doc: user "&3" not authorized - has roles ["&4"], requires one of ["&5"]',
                                                poOperation:Method,
                                                poOperation:ServiceURI,
                                                (if valid-handle(oCachedPrincipal:Token) then oCachedPrincipal:Token:user-id else '?':u),
                                                (if valid-handle(oCachedPrincipal:Token) then oCachedPrincipal:Token:roles else '?':u),
                                                OpenEdge.Core.String:Join(poOperation:AccessControl, '","':u) )).

        return lAuthorized.
    end method. // IsOperationAuthorized

    /**
        Creates the security schemes section for the OpenAPI document.
        Defines authentication mechanisms based on configuration (UseBasicAuth, UseBearerAuth).
        Only adds securitySchemes property to components if a scheme is configured.

        @param JsonObject The components object to conditionally add securitySchemes to
      */
    method protected void WriteSecuritySchemes (input poComponent as JsonObject):
        define variable schemes   as JsonObject no-undo.
        define variable schemeObj as JsonObject no-undo.

        // Only add a scheme if one was configured
        if cSecuritySchemeType eq ? or cSecuritySchemeName eq ? then
            return.

        case cSecuritySchemeName:
            when 'basicAuth':u then
            do:
                assign schemeObj = new JsonObject().
                schemeObj:Add('type':u, 'http':u).
                schemeObj:Add('scheme':u, 'basic':u).

                if cSecurityDesc gt '':u then
                    schemeObj:Add('description':u, cSecurityDesc).
                else if cBasicRealm gt '':u then
                    schemeObj:Add('description':u, substitute('HTTP Basic Authentication for realm "&1". Credentials are validated and converted to a Client-Principal token with associated roles.':u, cBasicRealm)).
                else
                    schemeObj:Add('description':u, 'HTTP Basic Authentication. Credentials are validated and converted to a Client-Principal token with associated roles.':u).

                assign schemes = new JsonObject().
                schemes:Add('basicAuth':u, schemeObj).
            end.

            when 'bearerAuth':u then
            do:
                assign schemeObj = new JsonObject().
                schemeObj:Add('type':u, 'http':u).
                schemeObj:Add('scheme':u, 'bearer':u).

                if cBearerFormat gt '':u then
                    schemeObj:Add('bearerFormat':u, cBearerFormat).

                if cSecurityDesc gt '':u then
                    schemeObj:Add('description':u, cSecurityDesc).
                else if cBearerFormat gt '':u then
                    schemeObj:Add('description':u, substitute('Bearer token authentication using &1 tokens. Token must include required roles.':u, cBearerFormat)).
                else
                    schemeObj:Add('description':u, 'Bearer token authentication. Token must include required roles.':u).

                assign schemes = new JsonObject().
                schemes:Add('bearerAuth':u, schemeObj).
            end.
        end case.

        // Only add securitySchemes property if we have schemes to add
        if valid-object(schemes) then
            poComponent:Add('securitySchemes':u, schemes).
    end method. // WriteSecuritySchemes

    /**
        Adds security requirements to an operation based on its AccessControl roles.
        If a security scheme is configured, references it with required roles.
        If no scheme is configured, uses x-required-roles extension instead.

        @param JsonObject The operation JSON object to add security to
        @param MappedOperation The operation containing AccessControl role requirements
      */
    method protected void WriteOperationSecurity (input pOperJson  as JsonObject,
                                                  input pOperation as MappedOperation):
        define variable secArray as JsonArray  no-undo.
        define variable secReq   as JsonObject no-undo.
        define variable roles    as JsonArray  no-undo.
        define variable i        as integer    no-undo.

        if not valid-object(pOperation) then
            return.

        // If no ACLs are defined, operation is accessible without authentication
        // Keep empty security array to explicitly indicate no authentication required
        if extent(pOperation:AccessControl) eq ? then
            return.

        // If role disclosure is not enabled, remove the security property
        // (operation is secured but we're not documenting the specific roles)
        if not lIncludeRoleOutput then
        do:
            pOperJson:Remove('security':u).
            return.
        end.

        // Build array of required roles from AccessControl
        assign roles = new JsonArray().
        do i = 1 to extent(pOperation:AccessControl):
            roles:Add(pOperation:AccessControl[i]).
        end.

        // Check if a security scheme was configured
        if cSecuritySchemeName gt '':u then
        do:
            // Standard OpenAPI security with scheme reference
            assign
                secArray = pOperJson:GetJsonArray('security':u)
                secReq   = new JsonObject()
                .
            secReq:Add(cSecuritySchemeName, roles).
            secArray:Add(secReq).

            this-object:Logger:Trace(substitute('Added security requirements for operation "&1 &2": roles [&3] via &4',
                                                pOperation:Method,
                                                pOperation:ServiceURI,
                                                OpenEdge.Core.String:Join(pOperation:AccessControl, ',':u),
                                                cSecuritySchemeName)).
        end.
        else
        do:
            // No scheme configured - use extension to document roles
            pOperJson:Add("x-required-roles":u, roles).

            this-object:Logger:Trace(substitute('Added x-required-roles extension for operation "&1 &2": [&3] (no security scheme configured)',
                                                pOperation:Method,
                                                pOperation:ServiceURI,
                                                OpenEdge.Core.String:Join(pOperation:AccessControl, ',':u))).
        end.
    end method. // WriteOperationSecurity

    /**
        Removes services and tags that have no accessible operations.
        Called after all operations have been written, to clean up empty services.
      */
    method protected void RemoveEmptyServices ():
        define variable oPathsJson        as JsonObject no-undo.
        define variable oTagsArray        as JsonArray  no-undo.
        define variable oNewTagsArray     as JsonArray  no-undo.

        // Variables for removing empty paths
        define variable cAllPaths         as character extent no-undo.
        define variable cCurrentPath      as character        no-undo.
        define variable oPathObj          as JsonObject       no-undo.
        define variable cHttpMethods      as character extent no-undo.
        define variable iPathLoop         as integer          no-undo.
        define variable iPathCount        as integer          no-undo.
        define variable cServiceName      as character        no-undo.
        define variable cServicesWithOps  as character        no-undo. // Comma-delimited list

        // Variables for rebuilding tags
        define variable oTagObj           as JsonObject no-undo.
        define variable cTagName          as character  no-undo.
        define variable iTagLoop          as integer    no-undo.
        define variable iTagCount         as integer    no-undo.

        this-object:Logger:Debug('RemoveEmptyServices: Starting cleanup').

        assign
            oPathsJson = cast(this-object:Value, JsonObject):GetJsonObject('paths':u)
            oTagsArray = cast(this-object:Value, JsonObject):GetJsonArray('tags':u)
            .

        /**
         * STEP 1: Remove paths that have no HTTP methods AND track which services remain.
         */
        assign
            cAllPaths  = oPathsJson:GetNames()
            iPathCount = extent(cAllPaths)
            .

        this-object:Logger:Debug(substitute('RemoveEmptyServices: Found &1 paths', iPathCount)).

        // Guard against no paths or unknown extent
        if iPathCount eq ? or iPathCount eq 0 then
        do:
            this-object:Logger:Debug('RemoveEmptyServices: No paths to process, clearing all tags').
            assign iPathCount = 0.
            // No paths means no services, clear all tags
            cast(this-object:Value, JsonObject):Set('tags':u, new JsonArray()).
            return.
        end.

        PATHSBLK:
        do iPathLoop = 1 to iPathCount:
            assign cCurrentPath = cAllPaths[iPathLoop].

            this-object:Logger:Trace(substitute('RemoveEmptyServices: Checking path &1', cCurrentPath)).

            if cCurrentPath gt '':u then
            do:
                extent(cHttpMethods) = ?. // Clear any previous extent for this list of methods.
                assign
                    oPathObj     = oPathsJson:GetJsonObject(cCurrentPath)
                    cHttpMethods = oPathObj:GetNames()
                    .

                // If path has no HTTP methods, remove it
                if extent(cHttpMethods) eq 0 or extent(cHttpMethods) eq ? then
                do:
                    this-object:Logger:Debug(substitute('RemoveEmptyServices: Removing empty path &1', cCurrentPath)).
                    oPathsJson:Remove(cCurrentPath).
                end.
                else
                do:
                    // Path has operations, track its service
                    // Extract service name from path (first segment after '/')
                    assign cServiceName = entry(1, substring(cCurrentPath, 2), '/':u).

                    // Add to list if not already present
                    if lookup(cServiceName, cServicesWithOps) eq 0 then
                    do:
                        this-object:Logger:Debug(substitute('RemoveEmptyServices: Service "&1" has operations', cServiceName)).
                        assign cServicesWithOps = cServicesWithOps
                                                + (if cServicesWithOps gt '' then ',' else '')
                                                + cServiceName.
                    end.
                end.
            end.
        end. // PATHSBLK

        this-object:Logger:Debug(substitute('RemoveEmptyServices: Services with operations: &1', cServicesWithOps)).

        /**
         * STEP 2: Build new tags array with only services that have operations.
         */
        assign
            oNewTagsArray = new JsonArray()
            iTagCount     = oTagsArray:Length
            .

        this-object:Logger:Debug(substitute('RemoveEmptyServices: Original tag count: &1', iTagCount)).

        if iTagCount gt 0 then
        do:
            TAGSBLK:
            do iTagLoop = 1 to iTagCount:
                assign
                    oTagObj  = oTagsArray:GetJsonObject(iTagLoop)
                    cTagName = oTagObj:GetCharacter('name':u)
                    .

                // Only keep tags for services that have operations
                if lookup(cTagName, cServicesWithOps) gt 0 then
                do:
                    this-object:Logger:Debug(substitute('RemoveEmptyServices: Keeping tag "&1"', cTagName)).
                    oNewTagsArray:Add(oTagObj).
                end.
                else
                    this-object:Logger:Debug(substitute('RemoveEmptyServices: Removing tag "&1" (no operations)', cTagName)).
            end. // TAGSBLK
        end.

        // Replace old tags array with new one
        cast(this-object:Value, JsonObject):Set('tags':u, oNewTagsArray).

        this-object:Logger:Debug(substitute('RemoveEmptyServices: Final tag count: &1', oNewTagsArray:Length)).
    end method. // RemoveEmptyServices

end class.