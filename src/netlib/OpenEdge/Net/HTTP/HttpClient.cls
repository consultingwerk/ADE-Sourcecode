/************************************************
Copyright (c) 2014-2017, 2019 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : HttpClient
    Purpose     : Public HttpClient. All client code should be written against this class. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 14 10:44:00 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.IAdaptable.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.ClientOptions.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.Filter.Writer.StatusCodeWriterBuilder.
using OpenEdge.Net.HTTP.HttpClient.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.ResponseBuilder.
using OpenEdge.Net.HTTP.Filter.Writer.AuthenticationRequestWriterBuilder.


class OpenEdge.Net.HTTP.HttpClient implements IHttpClient, ISupportInitialize, ISupportLogging:
    /** (mandatory) A free-text name for this http client. Used for the USER-AGENT
        string. */
    define public property ClientName as character no-undo get. private set.
    
    /** (mandatory) A free-text semantic version string for this http client. Used for the USER-AGENT
        string. */
    define public property ClientVersion as character no-undo get. private set.
    
    /** Miscellanous options (like timeouts) for this client */
    define public property Options as ClientOptions no-undo get. private set.
    
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo
        get():
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(get-class(HttpClient)). 
                
            return this-object:Logger.
        end get.
        set.
    
    /* Reference to the library that does the actual work. */
    define private variable moWwwLib as IHttpClientLibrary no-undo.
    
    /** Factory method for instantiating a new http client client.
        This "Instance" method remains because it's already used elsewhere.
        The ClientBuilder() should be called directly in most cases.
        
        @return HttpClient A useful, constructed HttpClient. */
    method static public HttpClient Instance():
        /* assumption is that the default client is this type: OpenEdge.Net.HTTP.HttpClient */
        return cast(ClientBuilder:Build():Client, HttpClient).
    end method.
    
    /** Constructor.
    
        @param character The name of this Http Client
        @param character The (semantic: major.minor.patch) version of this Http Client
        @param IHttpClientLibrary The library performing the actual work */
    constructor public HttpClient(input pcClientName    as character,
                                  input pcClientVersion as character,                                  
                                  input poLibrary as IHttpClientLibrary):
        Assert:NotNullOrEmpty(pcClientName, 'Client name').
        Assert:NotNullOrEmpty(pcClientVersion, 'Client version').
        Assert:NotNull(poLibrary, 'Http library').
        
        assign this-object:ClientName    = pcClientName
               this-object:ClientVersion = pcClientVersion
               this-object:Options       = new ClientOptions()
               
               moWwwLib = poLibrary
               .
    end constructor.

    destructor HttpClient():
        Destroy().
    end destructor. 
    
    /** Executes an HTTP request.
    
        If this code changes, the code in HttpClientDecorator should 
        too, to preserve the 'wrapper' nature of this method. 
        
        @param  HttpRequest Request parameters (URL, method, etc)  
        @return HttpResponse Includes status and payload */
    method public IHttpResponse Execute(input poRequest as IHttpRequest):
        define variable oResponse as IHttpResponse no-undo.
        
        assign oResponse = ResponseBuilder:Build():Response.
        
        Execute(poRequest, oResponse).
        
        return oResponse.
    end method.
            
    /** Executes an HTTP request.
        
        @param IHttpRequest Request parameters (URL, method, etc)  
        @param IHttpResponse Includes status and payload*/
    method public void Execute(input poRequest  as IHttpRequest,
                               input poResponse as IHttpResponse):
        define variable iNumRetries as integer no-undo.
        define variable rRequestHash as raw extent 2 no-undo.
        define variable oAuthRequest as IAuthenticatedRequest no-undo.
        
        Assert:NotNull(poRequest,  'Http request').
        Assert:NotNull(poResponse, 'Http response'). 
        
        assign iNumRetries = 0.
        /* Use looping instead of recursion to avoid deeping the call stack */
        repeat:
            if this-object:Options:NumRetries gt 0 then
            do:
               if iNumRetries eq 0 then
                    Logger:Debug(substitute('Initial request for &2 &3; max retries=&1',
                                      this-object:Options:NumRetries, poRequest:Method, poRequest:URI:ToString())).
                else
                    Logger:Debug(substitute('Retry attempt &1 of &2 for &3 &4',
                                    iNumRetries, this-object:Options:NumRetries, poRequest:Method, poRequest:URI:ToString())).
            end.
            
            /* Update the request as needed */
            AddUserAgent(poRequest).
            
            if type-of(poRequest, IAdaptable) then
                assign oAuthRequest = cast(cast(poRequest, IAdaptable):GetAdapter(get-class(IAuthenticatedRequest)),
                                           IAuthenticatedRequest).
            else
            if type-of(poRequest, IAuthenticatedRequest) then
                assign oAuthRequest = cast(poRequest, IAuthenticatedRequest).
            else
                assign oAuthRequest = ?.
            
            if valid-object(oAuthRequest) then
            do:
                Logger:Debug(substitute('Authenticated request: method = &1, challenge = &2',
                                oAuthRequest:AuthenticationMethod, oAuthRequest:AuthenticationChallenge)).
                oAuthRequest:AddAuthentication().
            end.
            
            assign rRequestHash[2] = rRequestHash[1].
            
            /* make the request.
               request timeouts must be handled by the client library */
            moWwwLib:Execute(poRequest, poResponse).
            
            assign rRequestHash[1] = poRequest:ContentMD5.
            
            /* Check for redirects, auth and friends */
            if ProcessStatusAction(poRequest, poResponse) then
                leave.
            
            if this-object:Options:NumRetries eq 0 then
            do:
                Logger:Info(substitute('Client will not attempt retry of &1 &2 after response status code &3',
                                poRequest:Method, poRequest:URI:ToString(), poResponse:StatusCode )).
                leave.
            end.
            else
            if this-object:Options:NumRetries gt 0 then
            do:
                if iNumRetries ge this-object:Options:NumRetries then
                    leave.
                if this-object:Options:PauseBetweenRetry gt 0 then
                    pause this-object:Options:PauseBetweenRetry no-message.
            end.
            
            if rRequestHash[1] eq rRequestHash[2] then
                assign iNumRetries = iNumRetries + 1.
            else
                assign iNumRetries = 0.
        end.
    end method.
    
    /** Process the action resulting from the status evaluation
        
        @param HttpResponse The response in question
        @return logical Returns TRUE if the loop is complete */
    method protected logical ProcessStatusAction(input poRequest  as IHttpRequest,
                                                 input poResponse as IHttpResponse):
        define variable oStatusCodeWriter as IHttpMessageWriter no-undo.
        define variable cookies as Cookie extent no-undo.
        
        assign oStatusCodeWriter = StatusCodeWriterBuilder:Build(poRequest, poResponse).    
        if valid-object(oStatusCodeWriter) then
        do:
            // Copy any cookies from the response into the request. This is typically some 
            // form of session cookie (JSESSIONID) or similar
            poResponse:GetCookies(output cookies).
            poRequest:SetCookies(cookies).
            
            // Now apply the response to the request
            oStatusCodeWriter:Open().
            oStatusCodeWriter:Write(poResponse).
            oStatusCodeWriter:Close().
            
            /* The writer may have changed the message (auth in particular), so use the
               writer's message in place of the input message. */
            assign poRequest = cast(oStatusCodeWriter:Message, IHttpRequest).
            
            /* status changes will require a retry */
            return false.
        end.
        
        /* with no status code processing, all done */
        return true.
    end method.
    
    /* Initializer/Startup */
    method public void Initialize():
    end method.
    
    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy():
        if type-of(moWwwLib, ISupportInitialize) then
            cast(moWwwLib, ISupportInitialize):Destroy().
    end method.
    
    /** Adds a User-Agent string relevant to this client.
    
        @param HttpRequest The request to which to add the user-agent string */
    method protected void AddUserAgent(input poRequest as IHttpRequest):
        /* Set the User-Agent string. Will look something like 
                OpenEdge-HttpClient/0.2.0 (WIN32/64) OpenEdge/11.5.0.0.1108 */
        poRequest:SetHeader(
            HttpHeaderBuilder:Build('User-Agent':u)
                    :Value(substitute('&1/&2 (&4/&5) OpenEdge/&3':u, 
                                this-object:ClientName,
                                this-object:ClientVersion,
                                proversion(1),
                                '{&OPSYS}':u,
                                '{&PROCESS-ARCHITECTURE}':u))
                    :Header).
    end method.
    
end class.
