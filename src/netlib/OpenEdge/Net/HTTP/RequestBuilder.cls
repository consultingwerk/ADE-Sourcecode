/************************************************
Copyright (c) 2014-2017, 2019 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : RequestBuilder
    Purpose     : Builds an HttpRequest for use with an HttpClient 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 20 11:48:05 EDT 2014
    Notes       : * this builder performs 2 functions:
                        1/ creates a useable Request object
                        2/ provides a fluent interface for setting values on that request
                  * A useable request requires a method and a URI  
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Core.IAdaptable.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.String.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Net.HTTP.AuthenticatedRequest.
using OpenEdge.Net.HTTP.AuthenticationMethodEnum.
using OpenEdge.Net.HTTP.BuilderRegistry.
using OpenEdge.Net.HTTP.ConfigBuilder.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.DefaultRequestBuilder.
using OpenEdge.Net.HTTP.Filter.Auth.AuthFilterEventHandlerWrapper.
using OpenEdge.Net.HTTP.Filter.Auth.IAuthFilterEventHandler.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.HttpRequestDecorator.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.ProxyHttpRequest.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using OpenEdge.Net.ISupportMultipartEntity.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.RequestBuilder abstract inherits ConfigBuilder
            implements ISupportInitialize:
    
    /* The first comma-delimited entry is considered the default value. */    
    define private variable mcJsonContentTypes as character no-undo
        init 'application/json':u.
        
    define private variable mcHtmlContentTypes as character no-undo
        init 'text/html':u.

    define private variable mcFormContentTypes as character no-undo
        init 'application/x-www-form-urlencoded':u.

    define private variable mcTextContentTypes as character no-undo
        init 'text/plain':u.

    define private variable mcXmlContentTypes as character no-undo
        init 'application/xml,text/xml,text/xml-external-parsed-entity,application/xml-external-parsed-entity,application/xml-dtd':u.     

    define private variable mcMultipartContentTypes as character no-undo
        init 'multipart/mixed':u.
             
    /** Registry for mapping build types to their implementations */
    define static public property Registry as BuilderRegistry no-undo
        get():
            define variable oRegistry as BuilderRegistry no-undo.
            if not valid-object(RequestBuilder:Registry) then
            do:
                assign oRegistry = new BuilderRegistry().
                RequestBuilder:InitializeRegistry(oRegistry).                
                assign RequestBuilder:Registry = oRegistry.
            end.
            return RequestBuilder:Registry.
        end get.
        private set.
    
    /** Each concrete builder will implement this differently */
    define abstract public property Request as IHttpRequest no-undo get.

    /** Adds initial values into the registry 
    
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as BuilderRegistry):
        /* default builder  */
        poRegistry:Put(get-class(RequestBuilder):TypeName, 
                       get-class(DefaultRequestBuilder)).
        
        /* default request, proxy request and authenticated request types */
        poRegistry:Put(get-class(IHttpRequest):TypeName,
                       get-class(HttpRequest)).
        poRegistry:Put(get-class(ISupportProxy):TypeName,
                       get-class(ProxyHttpRequest)).
        poRegistry:Put(get-class(IAuthenticatedRequest):TypeName, 
                       get-class(AuthenticatedRequest)).
                       
    end method.
    
    /** Constructor.
    
       @param character The HTTP method
       @param URI The target URI    */
    constructor protected RequestBuilder(input pcMethod as character,
                                         input poURI as URI):
        super().
        
        Assert:NotNullOrEmpty(pcMethod, 'Method').
        Assert:NotNull(poURI, 'URI').
        
        SetOption('uri':u, poURI).
        SetOption('method':u, pcMethod).
    end constructor.
    
    /** Builder director method.
        
        @return RequestBuilder A builder for the requested type */
    method static public RequestBuilder Build(input pcMethod as character,
                                              input poURI as URI):
        define variable oBuilderType as Progress.Lang.Class no-undo.
        define variable oRB as RequestBuilder no-undo.
        
        assign oBuilderType = RequestBuilder:Registry:Get(get-class(RequestBuilder):TypeName).
        Assert:IsType(oBuilderType, get-class(RequestBuilder)).

        oRB = dynamic-new string(oBuilderType:TypeName) (pcMethod, poURI).
        
        if type-of(oRB, ISupportInitialize) then
            cast(oRB, ISupportInitialize):Initialize().
        
        return oRB.
    end method.
    
    /** METHOD FACTORY METHODS BEGIN **/
    
    /** Returns a request builder for a default GET request 
        
        @param  character The target URI 
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Get(input pcURI as character):
        return RequestBuilder:Get(OpenEdge.Net.URI:Parse(pcURI), ?).
    end method.
                
    /** Returns a request builder for a default GET request 
        
        @param  URI The target URI 
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Get(input poURI as URI):
        return RequestBuilder:Get(poURI, ?).
    end method.

    /** Returns a request builder for a default GET request 
        
        @param  character The target URI
        @param  Object The message body/entity for the request
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Get(input pcURI as character, input poEntity as Object):
        return RequestBuilder:Get(OpenEdge.Net.URI:Parse(pcURI), poEntity).
    end method.
    
    /** Returns a request builder for a default GET request 
        
        @param  URI    The target URI
        @param  Object The message body/entity for the request
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Get(input poURI as URI, input poEntity as Object):
        return RequestBuilder
                    :Build(string(MethodEnum:GET), poURI)
                    :WithData(poEntity).
    end method.
    
    /** Returns a request builder for a default GET request 
        
        @param  URI    The target URI
        @param  Object The message body/entity for the request
        @param  character The content type of the entity
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Get(input poURI as URI,
                                            input poEntity as Object,
                                            input pcContentType as character):
        return RequestBuilder
                    :Build(string(MethodEnum:GET), poURI)
                    :WithData(poEntity, pcContentType).
    end method.

    /** Returns a request builder for a default PUT request 
        
        @param  character The target URI
        @param  Object The message body/entity for the request
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Put(input pcURI as character,
                                            input poEntity as Object):
        return RequestBuilder:Put(OpenEdge.Net.URI:Parse(pcURI), poEntity).                                                
    end method.
    
    /** Returns a request builder for a default PUT request 
        
        @param  URI    The target URI
        @param  Object The message body/entity for the request
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Put(input poURI as URI,
                                            input poEntity as Object):
        return RequestBuilder
                    :Build(string(MethodEnum:PUT), poURI)
                    :WithData(poEntity).
    end method.
    
    /** Returns a request builder for a default PUT request 
        
        @param  URI    The target URI
        @param  Object The message body/entity for the request
        @param  character The content type of the entity
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Put(input poURI as URI,
                                            input poEntity as Object,
                                            input pcContentType as character):
        return RequestBuilder
                    :Build(string(MethodEnum:PUT), poURI)
                    :WithData(poEntity, pcContentType).
    end method.
    
    /** Returns a request builder for an empty POST request 
        
        @param  character The target URI
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Post(input pcURI as character):
        return RequestBuilder:Post(OpenEdge.Net.URI:Parse(pcURI)).
    end method.

    /** Returns a request builder for an empty POST request 
        
        @param  URI    The target URI
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Post(input poURI as URI):
        return RequestBuilder:Build(string(MethodEnum:POST), poURI).
    end method.
    
    /** Returns a request builder for a default POST request 
        
        @param  character The target URI
        @param  Object The message body/entity for the request
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Post(input pcURI as character, input poEntity as Object):
        return RequestBuilder:Post(OpenEdge.Net.URI:Parse(pcURI), poEntity).
    end method.

    /** Returns a request builder for a default POST request 
        
        @param  URI    The target URI
        @param  Object The message body/entity for the request
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Post(input poURI as URI, input poEntity as Object):
        return RequestBuilder
                    :Build(string(MethodEnum:POST), poURI)
                    :WithData(poEntity).
    end method.
    
    /** Returns a request builder for a default POST request 
        
        @param  URI    The target URI
        @param  Object The message body/entity for the request
        @param  character The content type of the entity
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Post(input poURI as URI,
                                             input poEntity as Object,
                                             input pcContentType as character):
        return RequestBuilder
                    :Build(string(MethodEnum:POST), poURI)
                    :WithData(poEntity, pcContentType).
    end method.

    /** Returns a request builder for a default Patch request 
        
        @param  character The target URI
        @param  Object The message body/entity for the request
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Patch(input pcURI as character, input poEntity as Object):
        return RequestBuilder:Patch(OpenEdge.Net.URI:Parse(pcURI), poEntity).
    end method.

    /** Returns a request builder for a default Patch request 
        
        @param  URI    The target URI
        @param  Object The message body/entity for the request
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Patch(input poURI as URI, input poEntity as Object):
        return RequestBuilder
                    :Build(string(MethodEnum:PATCH), poURI)
                    :WithData(poEntity).
    end method.
    
    /** Returns a request builder for a default Patch request 
        
        @param  URI    The target URI
        @param  Object The message body/entity for the request
        @param  character The content type of the entity
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Patch(input poURI as URI,
                                             input poEntity as Object,
                                             input pcContentType as character):
        return RequestBuilder
                    :Build(string(MethodEnum:PATCH), poURI)
                    :WithData(poEntity, pcContentType).
    end method.
    
    /** Returns a request builder for a default DELETE request 
        
        @param  URI    The target URI
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Delete(input pcURI as character):
        return RequestBuilder:Delete(OpenEdge.Net.URI:Parse(pcUri)).
    end method.

    /** Returns a request builder for a default DELETE request 
        
        @param  character The target URI
        @param  Object The message body/entity for the request
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Delete(input pcURI as character, input poEntity as Object):
        return RequestBuilder:Delete(OpenEdge.Net.URI:Parse(pcUri), poEntity).
    end method.
    
    /** Returns a request builder for a default DELETE request 
        
        @param  URI The target URI
        @param  Object The message body/entity for the request
        @param  character The content type of the entity
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Delete(input poURI as URI,
                                               input poEntity as Object,
                                               input pcContentType as character):
        return RequestBuilder
                    :Build(string(MethodEnum:DELETE), poURI)
                    :WithData(poEntity, pcContentType).        
    end method.    
            
    /** Returns a request builder for a default DELETE request 
        
        @param  URI    The target URI
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Delete(input poURI as URI):
        return RequestBuilder:Delete(poURI, ?).
    end method.

    /** Returns a request builder for a default DELETE request 
        
        @param  URI    The target URI
        @param  Object The message body/entity for the request
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Delete(input poURI as URI, input poEntity as Object):
        return RequestBuilder
                    :Build(string(MethodEnum:DELETE), poURI)
                    :WithData(poEntity).
    end method.

    /** Returns a request builder for a default HEAD request 
        
        @param  character The target URI
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Head(input pcURI as character):
        return RequestBuilder:Head(OpenEdge.Net.URI:Parse(pcURI)).
    end method.

    /** Returns a request builder for a default HEAD request 
        
        @param  URI    The target URI
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Head(input poURI as URI):
        define variable oBuilder as RequestBuilder no-undo.
        
        oBuilder = RequestBuilder:Build(string(MethodEnum:HEAD), poURI).
        
        return oBuilder.
    end method.
    
    /** Returns a request builder for a default OPTIONS request 
        
        @param  character The target URI
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Options(input pcURI as character):
        return RequestBuilder:Options(OpenEdge.Net.URI:Parse(pcURI)).
    end method.

    /** Returns a request builder for a default OPTIONS request 
        
        @param  character The target URI
        @param  Object The message body/entity for the request
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Options(input pcURI as character, input poEntity as Object):
        return RequestBuilder:Options(OpenEdge.Net.URI:Parse(pcURI), poEntity).
    end method.
    
    /** Returns a request builder for a default OPTIONS request 
        
        @param  URI    The target URI
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Options(input poURI as URI):
        return RequestBuilder:Options(poURI, ?).
    end method.
    
    /** Returns a request builder for a default OPTIONS request 
        
        @param  URI    The target URI
        @param  Object The message body/entity for the request
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Options(input poURI as URI, input poEntity as Object):
        return RequestBuilder
                    :Build(string(MethodEnum:OPTIONS), poURI)
                    :WithData(poEntity).
    end method.
    
    /** Returns a request builder for a default OPTIONS request 
        
        @param  URI    The target URI
        @param  Object The message body/entity for the request
        @param  character The content type of the entity
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Options(input poURI as URI,
                                                input poEntity as Object,
                                                input pcContentType as character):
        return RequestBuilder
                    :Build(string(MethodEnum:OPTIONS), poURI)
                    :WithData(poEntity, pcContentType).
    end method.
    
    /** Returns a request builder for a default TRACE request 
        
        @param  character The target URI
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Trace(input pcURI as character):
        return RequestBuilder:Trace(OpenEdge.Net.URI:Parse(pcURI)).
    end method.
    
    /** Returns a request builder for a default TRACE request 
        
        @param  URI    The target URI
        @return RequestBuilder The request builder being constructed. */
    method static public RequestBuilder Trace(input poURI as URI):
        define variable oBuilder as RequestBuilder no-undo.
        
        oBuilder = RequestBuilder:Build(string(MethodEnum:TRACE), poURI).
        
        return oBuilder.
    end method.
    
/** METHOD FACTORY METHODS END **/
    method public void Destroy():
    end method.
    
    method public void Initialize():
        /* default values  */
        HttpVersion('HTTP/1.1':u).
    end method.
    
    /** Adds a JSON body to the request
         
        @param JsonObject The JSON data being added to the request
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder AddJsonData(input poEntity as JsonObject):
        return WithData(poEntity).
    end method.
    
    /** Adds a form data as a body to the request
         
        @param  IStringStringMap The complete data being added to the request
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder AddFormData(input poEntity as IStringStringMap):
        return WithData(poEntity).
    end method.

    /** Adds a form data as a body to the request
         
        @param  character The field name (key) for the data being added 
        @param  character The value for the field
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder AddFormData(input pcFieldName as character, input pcFieldValue as character):
        define variable oFormData as IStringStringMap no-undo.
        
        Assert:NotNullOrEmpty(pcFieldName, 'Field Name').
        
        
        assign oFormData = cast(GetOptionObjectValue('entity':u), IStringStringMap).
        if not valid-object(oFormData) then
        do:
            assign oFormData = new StringStringMap().
            AddFormData(oFormData).
        end.
        
        oFormData:Put(pcFieldName, pcFieldValue).

        return this-object.
    end method.
    
    /** Adds (or replaces) a cookie
        
        @param  Cookie The cookie 
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder AddCookie(input pCookie as Cookie):
        Assert:NotNull(pCookie, 'Http cookie').
        
        /* Requests are not allowed mutiple cookies with the same name. */
        SetOption('cookie+':u + pCookie:Name, pCookie).
        
        return this-object.
    end method.
    
    /** Adds (or replaces) a header
        
        @param  character The header name 
        @param  character The value 
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder AddHeader(input pcName as character, input pcValue as character):
        Assert:NotNullOrEmpty(pcName, 'Header name').
        Assert:NotNull(pcValue, 'Header value').
        
        return AddHeader(HttpHeaderBuilder:Build(pcName):Value(pcValue):Header).
    end method.

    /** Adds (or replaces) a header
        
        @param  HttpHeader The header  
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder AddHeader(input poHeader as HttpHeader):
        Assert:NotNull(poHeader, 'Http header').
                
        SetHeaderOption(poHeader).
        return this-object.
    end method.
        
    /** Sets the transfer encoding for the request 
        
        @param TransferEncodingEnum The encoding to use
        @return RequestBuilder The request builder being constructed. */     
    method public RequestBuilder WithTransferEncoding(input poEncoding as TransferEncodingEnum):
        Assert:NotNull(poEncoding, 'Transfer encoding').
        
        return AddHeader('Transfer-Encoding':u, string(poEncoding)).
    end method.

    /** Adds data to the request.
         
        @param Object The object to use as the request payload/entity
        @return RequestBuilder The request builder being constructed. */  
    method public RequestBuilder WithData(input poEntity as Object):
        if valid-object(poEntity) then
        /* Set some default values. These can be overridden via the ContentType()
           method.
           
           We use the first entry, since that's considered the default value. */
        case true:
            when poEntity:GetClass():IsA(get-class(JsonConstruct)) then
                return WithData(poEntity, entry(1, mcJsonContentTypes)).
            when poEntity:GetClass():IsA(get-class(WidgetHandle)) then
                return WithData(poEntity, entry(1, mcXmlContentTypes)).
            when poEntity:GetClass():IsA(get-class(String)) then
                return WithData(poEntity, entry(1, mcHtmlContentTypes)).
            when poEntity:GetClass():IsA(get-class(IStringStringMap)) then
                return WithData(poEntity, entry(1, mcFormContentTypes)).
            when poEntity:GetClass():IsA(get-class(ISupportMultipartEntity)) then
                return WithData(poEntity, entry(1, mcMultipartContentTypes)).
            otherwise
                return WithData(poEntity, entry(1, mcTextContentTypes)).
        end case.
                
        return this-object.
    end method.
    
    /** Adds data to the request.
        
        @param Object The object to use as the request payload/entity
        @param character The content type for this entity/payload
        @return RequestBuilder The request builder being constructed. */  
    method public RequestBuilder WithData(input poEntity as Object,
                                          input pcContentType as character):
        Assert:NotNull(poEntity, 'Data').
        Assert:NotNullOrEmpty(pcContentType, 'Content type').
        
        SetOption('entity':u, poEntity).
        ContentType(pcContentType).
        
        return this-object.
    end method.
    
    /** Flags the setting of the X-Request-Id header 
    
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder SendRequestId():
        return Id(guid).
    end method.

    /** Sets the X-Request-Id header. True or false (no unknowns allowed).
        
        @param logical True if the request id should be sent.     
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder Id(input pcRequestId as character):
        Assert:NotNullOrEmpty(pcRequestId, 'Request id').
        
        AddHeader('X-Request-ID':u, pcRequestId).
        
        return this-object.
    end method.
    
    /** Allows the request to accept all content types.  
    
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder AcceptAll():
        return this-object:AcceptContentType('*/*':u).
    end method.
    
    /** Allows the request to accept basic JSON content types.  
        
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder AcceptJson():
        return this-object:AcceptContentType(mcJsonContentTypes).
    end method.

    /** Allows the request to accept HTML content types  
    
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder AcceptHtml():
        return this-object:AcceptContentType(mcHtmlContentTypes).
    end method.
    
    /** Allows the request to accept form data content   
    
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder AcceptFormData():
        return this-object:AcceptContentType(mcFormContentTypes).
    end method.

    /** Allows the request to accept XML content types  
    
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder AcceptXml():
        return AcceptContentType(mcXmlContentTypes).
    end method.

    /** Allows the request to accept the input content type.
    
        @param character A content type. Must be non-empty, but otherwise not validated
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder AcceptContentType(input pcContentType as character):
        define variable cValue as character no-undo.
        
        assign cValue = GetOptionStringValue('AcceptContentType':u).
        if cValue eq ? then
            assign cValue = '':u.
        
        SetOption('AcceptContentType':u, cValue + ',':u + pcContentType).
        
        return this-object.
    end method.
    
    /** Sets the HTTP version of the request.
    
        @param character A version
        @return RequestBuilder The request builder being constructed. */
    method public RequestBuilder HttpVersion(input pcVersion as character):
        Assert:Equals('HTTP/1.1', pcVersion).
        
        SetOption('version':u, pcVersion).
        
        return this-object.
    end method.
    
    /** Add credentials for HTTP Basic authentication is required for the request.
        
        @param Credentials The credentials for the basic auth
        @return RequestBuilder This builder object */
    method public RequestBuilder UsingBasicAuthentication(input poCredentials as Credentials):
        return UsingCredentials(poCredentials,
                                string(AuthenticationMethodEnum:Basic),
                                'realm=""':u).
    end method.
       
    /** Add credentials for HTTP Digest authentication is required for the request.
        
        @param Credentials The credentials for the basic auth
        @return RequestBuilder This builder object */
    method public RequestBuilder UsingDigestAuthentication(input poCredentials as Credentials):
        Assert:NotNull(poCredentials, 'Credentials').
        
        SupportsAuthentication().
        SetOption('credentials':u, poCredentials).
        
        return this-object.
    end method.

    /** Add credentials to the HTTP Request 
        
        @param  Credentials The credentials for the basic auth
        @return RequestBuilder This builder object */
    method public RequestBuilder UsingCredentials(input poCredentials as Credentials):
        Assert:NotNull(poCredentials, 'Credentials').
        
        SupportsAuthentication().
        SetOption('credentials':u, poCredentials).
        
        return this-object.
    end method.
    
    /** Add credentials to the HTTP Request 
        
        @param  Credentials The credentials for the basic auth
        @param  AuthenticationMethodEnum The authentication method these credentials apply to
        @param  character The authentication challenge text
        @return RequestBuilder This builder object */
    method public RequestBuilder UsingCredentials(input poCredentials as Credentials,
                                                  input pcAuthenticationMethod as character,
                                                  input pcChallenge as character):
        Assert:NotNullOrEmpty(pcAuthenticationMethod, 'Authentication Method').
        Assert:NotNull(pcChallenge, 'Challenge').
        
        SupportsAuthentication().
        
        UsingCredentials(poCredentials).
            
        SetOption('authenticationmethod':u, pcAuthenticationMethod).
        SetOption('challenge':u, pcChallenge).
        
        return this-object.
    end method.
    

    /** Adds an authentication listener to events from the Request.
    
        @param Progress.Lang.Object The listening object. Must conform to the type  */
    method public RequestBuilder AuthCallback(input poListener as Object):
        return AddCallback(get-class(IAuthFilterEventHandler), poListener).
    end method.

    /** Adds a listener to events from the Request.
    
        @param Progress.Lang.Class The type of events the EventProviders is capable of 
                        listening to
        @param Progress.Lang.Object The listening object. Must conform to the type  */
    method public RequestBuilder AddCallback(input poEventListenerType as class Class,
                                             input poListener as Object):
        Assert:NotNull(poEventListenerType, 'Event listener type').
        Assert:NotNull(poListener, 'Event listener').
        
        SupportsAuthentication().
        
        SetOption('EventListenerType':u, poEventListenerType).
        SetOption('Listener':u, poListener).
        
        return this-object.
    end method.
    
    /** Adds an authentication listener to events from the Request.
    
        @param handle The listening procedure. Must conform to the type  */
    method public RequestBuilder AuthCallback(input phListener as handle):
        return AddCallback(get-class(IAuthFilterEventHandler),
                           new AuthFilterEventHandlerWrapper(phListener)).
    end method.
    
    /** Adds a listener to events from the Request.
    
        @param Progress.Lang.Class The type of events the EventProviders is capable of 
                        listening to
        @param handle The listening procedure. Must conform to the type  */
    method public RequestBuilder AddCallback(input poEventListenerType as class Class,
                                             input phListener as handle):
        /* Procedure listeners are only supported for IAuthFilterEventHandler */
        Assert:IsType(poEventListenerType, get-class(IAuthFilterEventHandler)).
        
        return AddCallback(poEventListenerType,
                           new AuthFilterEventHandlerWrapper(phListener)).                                             
    end method.
    
    /** Sets the URI to use as a proxy server for all requests
        
        @param URI The proxy server URI
        @return RequestBuilder This builder object. */
    method public RequestBuilder ViaProxy(input poProxyURI as URI):
        Assert:NotNull(poProxyURI, 'Proxy server URI').
        
        SupportsProxy().
        SetOption('ProxyURI':u, poProxyURI).
        
        return this-object.
    end method.
    
    /** Sets the URI to use as a proxy server for all requests
        
        @param character The proxy server URI
        @return RequestBuilder This builder object. */
    method public RequestBuilder ViaProxy(input pcProxyURI as character):
        Assert:NotNullOrEmpty(pcProxyURI, 'Proxy server URI').
            
        return ViaProxy(OpenEdge.Net.URI:Parse(pcProxyURI)).
    end method.
    
    /** Stores a header value as an option
        
        @param HttpHeader The header */
    method protected logical SetHeaderOption(input poHeader as HttpHeader):
        Assert:NotNull(poHeader, 'Http header').
        
        /* Requests are not allowed mutiple headers with the same name. */
        return SetOption('header+':u + poHeader:Name, poHeader).
    end method.
    
    /** Indicates that this request is capable of being proxied.
        This allows the proxy to be supplied later. 
     
        @return RequestBuilder This builder object */
    method public RequestBuilder SupportsProxy():
        SetOption('supportsProxy':u, string(true)).
        return this-object.
    end method.

    /** Indicates that this request is can handle authentication
        This allows credentials etc to be supplied later. 
     
        @return RequestBuilder This builder object */
    method public RequestBuilder SupportsAuthentication():
        SetOption('supportsAuthentication':u, string(true)).
        return this-object.
    end method.

    /** Sets the content type for the request.
     
        @param character The content type 
        @return RequestBuilder This builder object */
    method public RequestBuilder ContentType(input pcContentType as character):
        Assert:NotNullOrEmpty(pcContentType, 'Content type').
        
        return AddHeader('Content-Type':u, pcContentType).
    end method.


    /** Adds an ETag value to the request.
     
        @param character The tag value  
        @return RequestBuilder This builder object */
    method public RequestBuilder ETag(input pcETag as character):
        Assert:NotNullOrEmpty(pcETag, 'ETag ').
        
        /* Per RFC2616 the ETag value must be a quoted string */
        return AddHeader('ETag':u, quoter(pcETag)).
    end method.
        
    /** Decorate the request with additional behaviour
            
        @param  Class The type of decorator to use
        @param  IHttpRequest The request/instance we're decorating
        @return IHttpRequest The new, decorating request */
    method static public IHttpRequest DecorateRequest(input poDecorationType as Progress.Lang.Class,
                                                      input poDecoratedRequest as IHttpRequest):
        define variable oDecorator as IHttpRequest no-undo.
        define variable oDecoratorType as Progress.Lang.Class no-undo.
        define variable oRequest as IHttpRequest no-undo.
        define variable oAdapter as Progress.Lang.Object no-undo.
        
        Assert:NotNull(poDecoratedRequest, 'Request').
        Assert:NotNull(poDecorationType, 'Decoration type').
        
        /* if this is already decorated, carry on */
        if poDecoratedRequest:GetClass():IsA(poDecorationType) then
            return poDecoratedRequest.
        
        if type-of(poDecoratedRequest, IAdaptable) then
            assign oAdapter = cast(poDecoratedRequest, IAdaptable):GetAdapter(poDecorationType).
        
        if valid-object(oAdapter) and oAdapter:GetClass():IsA(poDecorationType) then
            return poDecoratedRequest.
        
        assign oDecoratorType = RequestBuilder:Registry:Get(poDecorationType:TypeName).
        if not valid-object(oDecoratorType) then
            return poDecoratedRequest.
        
        /* got to be able to decorate ... */
        Assert:IsType(oDecoratorType, get-class(HttpRequestDecorator)).
        
        oRequest = dynamic-new string(oDecoratorType:TypeName) (input poDecoratedRequest).

        if type-of(oRequest, ISupportInitialize) then
            cast(oRequest, ISupportInitialize):Initialize().
        
        return oRequest.
    end method.
    
end class.