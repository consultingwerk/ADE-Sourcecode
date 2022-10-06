/************************************************
Copyright (c) 2015, 2017, 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : DefaultRequestBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge, dugrau
    Created     : Thu Jan 15 12:16:45 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.Filter.Auth.IAuthFilterEventHandler.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.ISecureConnectionAuthenticatedRequest.
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.HTTP.ITraceableRequest.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.ServerConnection.ISocketConnectionCredentialsHandler.
using OpenEdge.Net.URI.
using OpenEdge.Security.ICredentials.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.DefaultRequestBuilder inherits RequestBuilder:

    define final override public property Request as IHttpRequest no-undo
        get():
            return NewRequest().
        end get.
    
    constructor public DefaultRequestBuilder (input pcMethod as character,
                                              input poURI as URI):
        super(pcMethod, poURI).
    end constructor.
    
    method private IHttpRequest NewRequest():
        define variable oRequest as IHttpRequest no-undo.
        define variable oRequestType as Progress.Lang.Class no-undo.
        define variable oListener as Object no-undo.
                        
        assign oRequestType = RequestBuilder:Registry:Get(get-class(IHttpRequest):TypeName).
        
        /* We know the signature to the default library's constructor - make sure that the type we
           get is of that type */
        Assert:IsType(oRequestType, get-class(IHttpRequest)).
        
        oRequest = dynamic-new string(oRequestType:TypeName)().
        
        if type-of(oRequest, ISupportInitialize) then
            cast(oRequest, ISupportInitialize):Initialize().
            
        assign oRequest:Method = GetOptionStringValue('method':u)
               oRequest:URI    = cast(GetOptionObjectValue('uri':u), URI).
                     
        /* version */
        if HasOption('version':u) then
            assign oRequest:Version = GetOptionStringValue('version':u).

        /* Accept content types.
           
           A content type provided via one of the :Accept*()
           methods takes precendence.
           
           If that doesn't exist, then take the valeu of any Accept
           header.
           
           If that doesn't exist, provide a default all */
        if HasOption('AcceptContentType':u) then
            AddHeader('Accept':u, trim(GetOptionStringValue('AcceptContentType':u), ',':u)).
        else
        if not HasOption('header+Accept':u) then
            AddHeader('Accept':u, '*/*':u).
        
        /* headers */
        for each ConfigOption where
                 ConfigOption.ParentBuilder eq integer(this-object) and
                 ConfigOption.ConfigName begins 'header+':u:
            oRequest:SetHeader(cast(ConfigOption.ObjectValue, HttpHeader)).
        end.
        
        /* cookies */
        for each ConfigOption where
                 ConfigOption.ParentBuilder eq integer(this-object) and
                 ConfigOption.ConfigName begins 'cookie+':u:
            oRequest:SetCookie(cast(ConfigOption.ObjectValue, Cookie)).
        end.
        
        /* data/entity */
        assign oRequest:Entity = GetOptionObjectValue('entity':u).
        
        /* proxy */
        if HasOption('supportsProxy':u) then
        do:
            assign oRequest = RequestBuilder:DecorateRequest(get-class(ISupportProxy), oRequest).
            if HasOption('ProxyURI':u) then
                cast(oRequest, ISupportProxy):ProxyURI = cast(GetOptionObjectValue('ProxyURI':u), URI).
        end.
        
        /* authenticated request */
        if HasOption('supportsAuthentication':u) then
        do:
            assign oRequest = RequestBuilder:DecorateRequest(get-class(IAuthenticatedRequest), oRequest).
            
            if HasOption('credentials':u) then
                assign cast(oRequest, IAuthenticatedRequest):Credentials = cast(GetOptionObjectValue('credentials':u), Credentials).
            
            if HasOption('authenticationMethod':u) then
                cast(oRequest, IAuthenticatedRequest):SetChallenge(
                            GetOptionStringValue('authenticationMethod':u),
                            GetOptionStringValue('challenge':u)     ).
            
            if HasOption('listener':u) then
                assign oListener = GetOptionObjectValue('listener':u). 
            if valid-object(oListener) and 
               type-of(oListener, IAuthFilterEventHandler) then
            cast(oRequest, IAuthenticatedRequest):AddAuthenticationCallback(
                    cast(oListener, IAuthFilterEventHandler)).                       
        end.

        /* client credentials */
        if HasOption('clientCredentials':u) then do:
            /* Utilize the decorator which supports secure connections (read: TLS), and set the client credentials as given */
            assign oRequest = RequestBuilder:DecorateRequest(get-class(ISecureConnectionAuthenticatedRequest), oRequest).
            assign cast(oRequest, ISecureConnectionAuthenticatedRequest):Credentials = cast(GetOptionObjectValue('clientCredentials':u), ICredentials).
        end.
        else if can-find(first ConfigOption no-lock
                         where ConfigOption.ParentBuilder eq integer(this-object)
                           and ConfigOption.ConfigName begins 'clientCredentialsCallback':u) then do:
            /* client credentials callback(s) */
            assign oRequest = RequestBuilder:DecorateRequest(get-class(ISecureConnectionAuthenticatedRequest), oRequest).

            /* Add each callback to the request. */
            for each ConfigOption where
                     ConfigOption.ParentBuilder eq integer(this-object) and
                     ConfigOption.ConfigName begins 'clientCredentialsCallback':u:
                cast(oRequest, ISecureConnectionAuthenticatedRequest):AddCallback(cast(ConfigOption.ObjectValue, ISocketConnectionCredentialsHandler)).
            end.
        end.

        /* allow tracing */
        if HasOption('allowTracing':u) then do:
            /* always decorate the request when the allowTracing option is present, whether tracing or not */
            assign oRequest = RequestBuilder:DecorateRequest(get-class(ITraceableRequest), oRequest).

            /* if tracing is not explicitly enabled, then mark the request to not allow tracing (opt-out) */
            if GetOptionLogicalValue('allowTracing':u) ne true then
                cast(oRequest, ITraceableRequest):DisableTracing().
        end.

        return oRequest.
    end method.
    
end class.