/************************************************
Copyright (c) 2015, 2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : DefaultRequestBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
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
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.DefaultRequestBuilder inherits RequestBuilder:
    define override public property Request as IHttpRequest no-undo
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
        define variable cName as character no-undo.
        define variable cValue as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
                        
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
        
        return oRequest.
    end method.
    
end class.