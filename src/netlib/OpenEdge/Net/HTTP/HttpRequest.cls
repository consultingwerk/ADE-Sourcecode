/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : HttpRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 18 13:24:00 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IStringCollection.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Core.Collections.StringCollection.
using OpenEdge.Core.Memptr.
using OpenEdge.Net.HTTP.AuthenticationMethodEnum.
using OpenEdge.Net.HTTP.ConcreteHttpRequest.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.Filter.Auth.AuthFilterList.
using OpenEdge.Net.HTTP.Filter.Message.MessageFilterList.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.URI.
using Progress.Lang.Class.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.Filter.Payload.JsonAddEntityFilter.
using OpenEdge.Net.HTTP.Filter.Payload.FormDataAddEntityFilter.
using OpenEdge.Net.HTTP.Filter.Payload.HtmlAddEntityFilter.
using OpenEdge.Net.HTTP.Filter.Auth.BasicAuthenticationFilter.
using OpenEdge.Net.HTTP.Filter.Auth.DigestAuthenticationFilter.
using OpenEdge.Net.HTTP.Filter.Auth.NoAuthenticationFilter.
using OpenEdge.Net.HTTP.Filter.Payload.XmlAddEntityFilter.
using OpenEdge.Net.HTTP.Filter.Payload.NoneAddEntityFilter.
using OpenEdge.Net.HTTP.Filter.Payload.JsonExtractEntityFilter.
using OpenEdge.Net.HTTP.Filter.Payload.FormDataExtractEntityFilter.
using OpenEdge.Net.HTTP.Filter.Payload.HtmlExtractEntityFilter.
using OpenEdge.Net.HTTP.Filter.Payload.XmlExtractEntityFilter.

class OpenEdge.Net.HTTP.HttpRequest inherits HttpMessage
            abstract:
                
    /* Holds filters for processing the entity content: one for adding an entity 
       to a request, and one for creating a message body from an an entity */
    define private variable moAddEntityFilter     as MessageFilterList no-undo.
    define private variable moExtractEntityFilter as MessageFilterList no-undo.
    
    /* Holds filters for processing authentication */
    define private variable moAuthFilter as AuthFilterList no-undo.
    
    /* Holds filters for processing authentication */
    define private variable moUrlFilters as MessageFilterList no-undo.
    
    /** (mandatory) GET/PUT/POST etc. Defaults to GET. */
    define public property Method as MethodEnum no-undo get. private set.
    
    /** (mandatory) The URI to request eg. http://progress.com/ */
    define public property URI as URI no-undo get. private set. 
    
    define public property AcceptContentType as IStringCollection no-undo get. private set.
    
    /** The authentication method for this request. Defaults to AuthenticationMethodEnum:None */
    define public property AuthenticationMethod as AuthenticationMethodEnum no-undo get. private set.

    /* Private 'holder' variable so that we can distinguish between credentials
       set against the HttpRequest and those from the URI. */        
    define private variable moRequestCredentials as Credentials no-undo.
    
    /** Credentials  to be used for authentication */
    define public property Credentials as Credentials no-undo
        get():
            /* If we have not overridden the credentials, check if there
               are any on the URI. */
            if not valid-object(moRequestCredentials) and
               valid-object(this-object:URI:Credentials) then
                return this-object:URI:Credentials.
            
            return moRequestCredentials.
        end get.
        private set(input poCredentials as Credentials):
            assign moRequestCredentials = poCredentials.
        end set.
    
    /** The challenge text required for creating the authentication response, 
        typically from a 401/Unauthorized response. This is usually the contents
        of the WWW-Authenticate header, but might also be a chunk of HTML for 
        Forms-based authentication requests.        */
    define public property AuthenticationChallenge as character no-undo get. private set.
    
    /** (optional) */
	define override public property Entity as Object no-undo
        get.
        set(input poEntity as Object):
            assign this-object:Entity = poEntity.
            AddEntity().
        end set.
        
    /** A hash value of this request, possible used for comparing 2 requests.
        This value is only set when the request is being built (since then we
        have all the info) */
    define public property Hash as raw no-undo get. private set.
    
    constructor public HttpRequest(input poMethod as MethodEnum,
                                   input poURI as URI):
        Assert:NotNull(poMethod, 'Method').
        Assert:NotNull(poURI, 'URI').
        
        assign this-object:URI = poURI
               this-object:Method = poMethod
               this-object:AcceptContentType = new StringCollection().
    end constructor.
    
    method static public HttpRequest Instance(input poMethod as MethodEnum,
                                              input poURI as URI):
        define variable oRequest as HttpRequest no-undo.
        
        oRequest = new ConcreteHttpRequest(poMethod, poURI).
        oRequest:Initialize().
        /* default 'cos it's all we have */
        oRequest:Version = 'HTTP/1.1'.
        
        return oRequest.
    end method.                                                   
    
    method override public void Initialize(  ):
        super:Initialize().
        
        assign this-object:AuthenticationMethod = AuthenticationMethodEnum:None
               this-object:Hash = ?.
        
        InitializeAuthFilters().
        InitializeEntityFilters().
        InitializeUrlFilters().
        
        /* We can only filter the URI after the filter chain has been initialised */
        if valid-object(this-object:URI) then
            FilterURI().
    end method.
    
    method override public void Destroy(  ):
        super:Destroy().
        
        DestroyUrlFilters().
        DestroyEntityFilters().
        DestroyAuthFilters().
    end method.

    method protected void InitializeEntityFilters():
        moAddEntityFilter = new MessageFilterList().
        
        AddMessageFilter(moAddEntityFilter, get-class(JsonAddEntityFilter)).
        AddMessageFilter(moAddEntityFilter, get-class(FormDataAddEntityFilter)).
        AddMessageFilter(moAddEntityFilter, get-class(HtmlAddEntityFilter)).
        AddMessageFilter(moAddEntityFilter, get-class(XmlAddEntityFilter)).
        AddMessageFilter(moAddEntityFilter, get-class(NoneAddEntityFilter)).
        
        moExtractEntityFilter = new MessageFilterList().
        AddMessageFilter(moExtractEntityFilter, get-class(JsonExtractEntityFilter)).
        AddMessageFilter(moExtractEntityFilter, get-class(FormDataExtractEntityFilter)).
        AddMessageFilter(moExtractEntityFilter, get-class(HtmlExtractEntityFilter)).
        AddMessageFilter(moExtractEntityFilter, get-class(XmlExtractEntityFilter)).
    end method.
    
    method protected void DestroyEntityFilters():
        assign moAddEntityFilter     = ?
               moExtractEntityFilter = ?.
    end method.    

    method protected void InitializeAuthFilters():
        moAuthFilter = new AuthFilterList().
        
        AddMessageFilter(moAuthFilter, get-class(BasicAuthenticationFilter)).
        AddMessageFilter(moAuthFilter, get-class(DigestAuthenticationFilter)).
        AddMessageFilter(moAuthFilter, get-class(NoAuthenticationFilter)).
    end method.
    
    method protected void InitializeUrlFilters():
        moUrlFilters = new MessageFilterList().
        
        /* Example 
        AddMessageFilter(moUrlFilters, get-class(ProgressUrlFilter)).
        */ 
    end method.
    
    method protected void DestroyUrlFilters():
        assign moUrlFilters = ?.        
    end method.
    
    method protected void DestroyAuthFilters():
        assign moAuthFilter = ?.
    end method.
    
    method protected void AddAuthentication():
        moAuthFilter:Filter(input this-object).
    end method.
        
    method public void SetUri(input pcURI as character):
        SetUri(OpenEdge.Net.URI:Parse(pcURI)).            
    end method.

    method public void SetUri(input poURI as URI):
        CheckSeal().
        
        Assert:NotNull(poURI, 'URI').
                
        this-object:URI = poURI.
    end method.

    method private void FilterURI():
        moUrlFilters:Filter(input this-object).
    end method.
    
    method private void AddEntity():
        moAddEntityFilter:Filter(input this-object).
    end method.
    
    /** Builds a complete HTTP request (ie headers, protocol etc)
        for the data in this object.
        
        @param  IHttpClientLibrary The library for which we are building this 
                                   request
        @return Memptr A memptr class containing the request. This will usually
                       be passed to the HTTP library.   */
    method public class Memptr BuildRequest(input poHttpLibrary as IHttpClientLibrary):
        define variable oIterator as IIterator no-undo.
        define variable oEntry as MapEntry no-undo.
        define variable cAcceptTypes as character no-undo.
        define variable cDelimiter as character no-undo.
        define variable cCredentials as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oRequest as ByteBucket no-undo.
        define variable oRequestData as class Memptr no-undo.
        
        assign oRequest = ByteBucket:Instance().
        
        /* REQUEST LINE */
        oRequest:PutString(substitute('&1 &2 &3~r~n',
                                this-object:Method:Name,
                                this-object:URI:RelativeURI,
                                this-object:Version      )).
        
        WriteHeader(oRequest, "Host",
                    this-object:URI:Host + 
                    (if this-object:URI:Port eq ? then '' else ':' + string(this-object:URI:Port))).
        
        /* AUTHENTICATION */
        AddAuthentication().
        
        /* HEADERS */
        WriteHeader(oRequest, 'User-Agent',
                    substitute('&1/&2 OpenEdge/&3', 
                        poHttpLibrary:LibraryName,
                        poHttpLibrary:LibraryVersion,
                        proversion)).
        
        oIterator = GetHeaderIterator().
        do while oIterator:HasNext():
            assign oEntry = cast(oIterator:Next(), MapEntry).
            WriteHeader(oRequest, 
                oEntry:Key:ToString(), oEntry:Value:ToString()).
        end.    /* header */
        
        /* ACCEPT-CONTENT-TYPE */
        assign oIterator = this-object:AcceptContentType:Iterator()
               cDelimiter = ''.
        do while oIterator:HasNext():
            assign cAcceptTypes = cAcceptTypes
                                + cDelimiter
                                + oIterator:Next():ToString()
                   cDelimiter = ','.
        end.
        
        /* Default to all */
        if cAcceptTypes eq '' then
            cAcceptTypes = '*/*'.
        WriteHeader(oRequest, 'Accept', cAcceptTypes).
        
        /* TRANSFER ENCODING */
        if valid-object(this-object:TransferEncoding) then
            WriteHeader(oRequest, 'Accept-Encoding', lc(this-object:TransferEncoding:Name)).
        
        /* COOKIES */
        oIterator = GetCookiesIterator().
        do while oIterator:HasNext():
            WriteHeader(oRequest,
                        'Cookie', oIterator:Next():ToString()).
        end.
        
        /* PAYLOAD/BODY */
        if valid-object(this-object:Entity) then
        do:
            /* Extract the Entity into the message body. Do this first
               because this extraction will calculate the content length,
               type etc. */
            PopulateMessageBody().
            
            WriteHeader(oRequest,
                        'Content-Length',   string(this-object:ContentLength)).
            WriteHeader(oRequest,
                        'Content-Type',     this-object:ContentType).
            WriteHeader(oRequest,
                        'Content-Encoding', this-object:ContentTypeEncoding).
        end.
        
        /* ALWAYS add a trailing CRLF to indicate end of headers. */
        oRequest:PutString('~r~n').
        
        /* Add Body to payload */
        if valid-object(this-object:MessageBody) and this-object:MessageBody:Size gt 0 then
            oRequest:PutBytes(this-object:MessageBody).
        
        assign oRequestData = oRequest:GetBytes().
               this-object:Hash = oRequestData:GetHash().
        
        return oRequestData.
    end method.
    
    method private void WriteHeader(input poBody as ByteBucket,
                                    input pcName as character,
                                    input pcValue as character):
        poBody:PutString(substitute('&1: &2~r~n', 
                            trim(pcName), 
                            pcValue)).
    end method.
    
    /** Sets the authentication challenge information for this request. 
        
        @param AuthenticationMethodEnum The authentication method
        @param Credentials A set of credentials for this request
        @param character The challenge text     */
    method public void SetChallenge(input poAuthMethod as AuthenticationMethodEnum,
                                    input poCredentials as Credentials,
                                    input pcChallenge as character):
        CheckSeal().
        Assert:NotNull(poAuthMethod, 'Authentication method').
        
        assign this-object:AuthenticationMethod    = poAuthMethod
               this-object:Credentials             = poCredentials
               this-object:AuthenticationChallenge = pcChallenge.
    end method.
    
    /** Adds a class as a subscriber to the events from a particular EventProvider.
        
        @param Progress.Lang.Class The type of events the EventProviders is capable of 
                        listening to
        @param Progress.Lang.Object The EventProvider.   */
    method public void AddFilterCallback(input poEventListenerType as class Class,
                                         input poListener as Object):
        moAuthFilter:AddFilterCallback(poEventListenerType, poListener).                                             
    end method.
    
    method protected void PopulateMessageBody():
        moExtractEntityFilter:Filter(this-object).
        this-object:ContentLength = this-object:MessageBody:Size.
    end method.
    
end class. 