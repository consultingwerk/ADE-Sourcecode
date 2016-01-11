/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : RequestBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 20 11:48:05 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Net.HTTP.AuthenticationMethodEnum.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.RequestBuilder: 
/*
HttpResponse = HttpClient:From(<char URI>|objURI)
       :Accept(<accept types>)
       :Header(name, value):Header(...
       :Cookie(name, value):Cookie(...
       :
       [:Get() | :Put(objBody|memptr) |:Post(objBody|memptr) |:Delete(objBody|memptr) | Head/Options/... ]
       
 - HttpResponse:Entity
 - HttpResponse:Request        
        
HttpRequestBuilder:postRequest('url'):withBasicAuth('usr', 'pass'):withBody(reqData):build().

HttpResponse = HttpClient:Execute(HttpRequest).

    orequest = RequestBuilder:Get():Request.
*/
        
    define public property Request as HttpRequest no-undo get. private set.
    
    constructor private RequestBuilder(input poMethod as MethodEnum,
                                       input poURI as URI):
        this-object:Request = HttpRequest:Instance(poMethod, poURI).                                           
    end constructor.
    
    method static public RequestBuilder Instance(input poMethod as MethodEnum,
                                                 input poURI as URI):
        return new RequestBuilder(poMethod, poURI).
    end method.
    
    method static public RequestBuilder Get(input pcURI as character):
        return RequestBuilder:Get(URI:Parse(pcURI), ?).
    end method.
                
    method static public RequestBuilder Get(input poURI as URI):
        return RequestBuilder:Get(poURI, ?).
    end method.

    method static public RequestBuilder Get(input pcURI as character, input poEntity as Object):
        return RequestBuilder:Get(URI:Parse(pcURI), poEntity).
    end method.
    
    method static public RequestBuilder Get(input poURI as URI, input poEntity as Object):
        define variable oBuilder as RequestBuilder no-undo.
        
        oBuilder = RequestBuilder:Instance(MethodEnum:GET, poURI).
        if valid-object(poEntity) then
            oBuilder:Request:Entity = poEntity.
        
        return oBuilder.
    end method.

    method static public RequestBuilder Put(input pcURI as character,
                                            input poEntity as Object):
        return RequestBuilder:Put(URI:Parse(pcURI), poEntity).                                                
    end method.
    
    method static public RequestBuilder Put(input poURI as URI,
                                            input poEntity as Object):
        define variable oBuilder as RequestBuilder no-undo.
        
        oBuilder = RequestBuilder:Instance(MethodEnum:PUT, poURI).
        if valid-object(poEntity) then
            oBuilder:Request:Entity = poEntity. 
        
        return oBuilder.
    end method.

    method static public RequestBuilder Post(input pcURI as character, input poEntity as Object):
        return RequestBuilder:Post(URI:Parse(pcURI), poEntity).
    end method.

    method static public RequestBuilder Post(input poURI as URI, input poEntity as Object):
        define variable oBuilder as RequestBuilder no-undo.
        
        oBuilder = RequestBuilder:Instance(MethodEnum:POST, poURI).
        if valid-object(poEntity) then
            oBuilder:Request:Entity = poEntity. 
        
        return oBuilder.
    end method.
    
    method static public RequestBuilder Delete(input pcURI as character):
        return RequestBuilder:Delete(URI:Parse(pcUri)).
    end method.

    method static public RequestBuilder Delete(input pcURI as character, input poEntity as Object):
        return RequestBuilder:Delete(URI:Parse(pcUri), poEntity).
    end method.
            
    method static public RequestBuilder Delete(input poURI as URI):
        return RequestBuilder:Delete(poURI, ?).
    end method.

    method static public RequestBuilder Delete(input poURI as URI, input poEntity as Object):
        define variable oBuilder as RequestBuilder no-undo.
        
        oBuilder = RequestBuilder:Instance(MethodEnum:DELETE, poURI).
        if valid-object(poEntity) then
            oBuilder:Request:Entity = poEntity. 
        
        return oBuilder.
    end method.
    
    method static public RequestBuilder Head(input pcURI as character):
        return RequestBuilder:Head(URI:Parse(pcURI)).
    end method.
    
    method static public RequestBuilder Head(input poURI as URI):
        define variable oBuilder as RequestBuilder no-undo.
        
        oBuilder = RequestBuilder:Instance(MethodEnum:HEAD, poURI).
        
        return oBuilder.
    end method.
    
    method static public RequestBuilder Options(input pcURI as character):
        return RequestBuilder:Options(URI:Parse(pcURI)).
    end method.

    method static public RequestBuilder Options(input pcURI as character, input poEntity as Object):
        return RequestBuilder:Options(URI:Parse(pcURI), poEntity).
    end method.
    
    method static public RequestBuilder Options(input poURI as URI):
        return RequestBuilder:Options(poURI, ?).
    end method.
    
    method static public RequestBuilder Options(input poURI as URI, input poEntity as Object):
        define variable oBuilder as RequestBuilder no-undo.
        
        oBuilder = RequestBuilder:Instance(MethodEnum:OPTIONS, poURI).
        if valid-object(poEntity) then
            oBuilder:Request:Entity = poEntity. 
        
        return oBuilder.
    end method.
    
    method static public RequestBuilder Trace(input pcURI as character):
        return RequestBuilder:Trace(URI:Parse(pcURI)).
    end method.
    
    method static public RequestBuilder Trace(input poURI as URI):
        define variable oBuilder as RequestBuilder no-undo.
        
        oBuilder = RequestBuilder:Instance(MethodEnum:TRACE, poURI).
        
        return oBuilder.
    end method.
    
    method public RequestBuilder AddJsonData(input poEntity as JsonObject):
        assign this-object:Request:Entity = poEntity.
        
        return this-object.
    end method.
    
    method public RequestBuilder AddFormData(input poEntity as IStringStringMap):
        assign this-object:Request:Entity = poEntity.
        
        return this-object.
    end method.

    method public RequestBuilder AddFormData(input pcFieldName as character, input pcFieldValue as character):
        Assert:NotNullOrEmpty(pcFieldName, 'Field Name').
        
        if not valid-object(this-object:Request:Entity) then
            assign this-object:Request:Entity = new StringStringMap().
        
        cast(this-object:Request:Entity, IStringStringMap):Put(pcFieldName, pcFieldValue).
        
        return this-object.
    end method.
    
    method public RequestBuilder AddHeader(input pcName as character, input pcValue as character):
        Assert:NotNullOrEmpty(pcName, 'Header name').
        
        this-object:Request:AddHeader(pcName, pcValue).
        return this-object.
    end method.
    
    method public RequestBuilder WithTransferEncoding(input poEncoding as TransferEncodingEnum):
        this-object:Request:TransferEncoding = poEncoding.
        
        return this-object.
    end method.
    
    method public RequestBuilder AcceptAll():
        return this-object:AcceptContentType('*/*').
    end method.
    
    method public RequestBuilder AcceptJson():
        return this-object:AcceptContentType('application/json').
    end method.

    method public RequestBuilder AcceptHtml():
        return this-object:AcceptContentType('text/html').
    end method.
    
    method public RequestBuilder AcceptFormData():
        return this-object:AcceptContentType('application/x-www-form-urlencoded').
    end method.

    method public RequestBuilder AcceptXml():
        this-object:Request:AcceptContentType:Add('text/xml').
        this-object:Request:AcceptContentType:Add('application/xml').
        this-object:Request:AcceptContentType:Add('text/xml-external-parsed-entity').
        this-object:Request:AcceptContentType:Add('application/xml-external-parsed-entity').
        this-object:Request:AcceptContentType:Add('application/xml-dtd').
        
        return this-object.
    end method.
    
    method public RequestBuilder AcceptContentType(input pcContentType as character):
        this-object:Request:AcceptContentType:Add(pcContentType).
        
        return this-object.
    end method.
    
    method public RequestBuilder HttpVersion(input pcVersion as character):
        this-object:Request:Version = pcVersion.
        
        return this-object.
    end method.
    
    /** Add credentials for HTTP Basic authentication is required for the request.
        
        @param Credentials The credentials for the basic auth
        @return RequestBuilder This builder object */
    method public RequestBuilder UsingBasicAuthentication(input poCredentials as Credentials):
        Assert:NotNull(poCredentials, 'Credentials').
        this-object:Request:SetChallenge(
                    AuthenticationMethodEnum:Basic,
                    poCredentials,
                    substitute('realm="&1"', poCredentials:Domain)).
        return this-object.
    end method.
       
    /** Add credentials for HTTP Digest authentication is required for the request.
        
        @param Credentials The credentials for the basic auth
        @return RequestBuilder This builder object */
    method public RequestBuilder UsingDigestAuthentication(input poCredentials as Credentials):
        Assert:NotNull(poCredentials, 'Credentials').
        this-object:Request:SetChallenge(
                    AuthenticationMethodEnum:Digest,
                    poCredentials,
                    substitute('realm="&1"', poCredentials:Domain)).
        return this-object.
    end method.

    /** Add credentials to the HTTP Request 
        
        @param Credentials The credentials for the basic auth
        @return RequestBuilder This builder object */
    method public RequestBuilder UsingCredentials(input poCredentials as Credentials):
        Assert:NotNull(poCredentials, 'Credentials').
        
        this-object:Request:SetChallenge(
                    AuthenticationMethodEnum:None,
                    poCredentials,
                    '').
        return this-object.
    end method.
        
    /** Adds a listener to events from the Request.
    
        @param Progress.Lang.Class The type of events the EventProviders is capable of 
                        listening to
        @param Progress.Lang.Object The listening object. Must conform to the type  */
    method public RequestBuilder AddCallback(input poEventListenerType as class Class,
                                             input poListener as Object):
        Assert:NotNull(poEventListenerType, 'Event listener type').
        Assert:NotNull(poListener, 'Event listener').
        
        this-object:Request:AddFilterCallback(poEventListenerType, poListener).
        
        return this-object.
    end method. 
    
end class.