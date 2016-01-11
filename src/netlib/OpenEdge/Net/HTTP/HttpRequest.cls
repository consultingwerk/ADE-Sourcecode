/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.Memptr.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IStringCollection.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Core.Collections.StringCollection.
using OpenEdge.Net.HTTP.Filter.Entity.EntityContentTypeFilter.
using OpenEdge.Net.HTTP.Filter.Entity.EntityFilterList.
using OpenEdge.Net.HTTP.Filter.Entity.EntityFilterNode.
using OpenEdge.Net.HTTP.Filter.Entity.FormDataEntityFilter.
using OpenEdge.Net.HTTP.Filter.Entity.HtmlEntityFilter.
using OpenEdge.Net.HTTP.Filter.Entity.JsonEntityFilter.
using OpenEdge.Net.HTTP.Filter.Entity.XmlEntityFilter.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.IHttpClientLibrary.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.URI.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.HttpRequest inherits HttpMessage:
    define protected variable moEntityContentFilter as EntityFilterList no-undo.
    
    /** (mandatory) GET/PUT/POST etc. Defaults to GET. */
    define public property Method as MethodEnum no-undo get. private set.
    
    /** (mandatory) The URI to request eg. http://progress.com/ */
    define public property URI as URI no-undo get. private set. 
    
    define public property AcceptContentType as IStringCollection no-undo get. private set.
    
    /** (optional) */
	define override public property Entity as Object no-undo
        get():
            return moEntity.
        end get.
        set(input poEntity as Object):
            /* Also set the content type */	              
            if valid-object(poEntity) then
                AddEntity(poEntity).
            else
                RemoveEntity().
        end set.
    
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
        
        oRequest = new HttpRequest(poMethod, poURI).
        oRequest:Initialize().
        /* default 'cos it's all we have */
        oRequest:Version = 'HTTP/1.1'.
        
        return oRequest.
    end method.                                                   
    
    method override public void Initialize(  ):
        super:Initialize().
        
        InitializeEntityContentFilters().
    end method.

    method protected void InitializeEntityContentFilters():
        assign moEntityContentFilter = new EntityFilterList().
        
        AddEntityContentFilter(new JsonEntityFilter(this-object)).
        AddEntityContentFilter(new FormDataEntityFilter(this-object)).
        AddEntityContentFilter(new XmlEntityFilter(this-object)).
        AddEntityContentFilter(new HtmlEntityFilter(this-object)).
    end method.
    
    method public void SetUri(input pcURI as character):
        SetUri(OpenEdge.Net.URI:Parse(pcURI)).            
    end method.
    
    method public void SetUri(input poURI as URI):
        CheckSeal().
        
        Assert:NotNull(poURI, 'URI').
        
        this-object:URI = poURI.
    end method.
    
    method protected void AddEntityContentFilter(input poFilter as EntityContentTypeFilter):
        Assert:NotNull(poFilter, 'Entity Content Type Filter').
        moEntityContentFilter:InsertLast(new EntityFilterNode(poFilter)).
    end method.
    
    method public void RemoveEntityContentFilter():
        moEntityContentFilter = ?.
    end method.
    
    method private void RemoveEntity():
        assign this-object:ContentType = ? 
               this-object:ContentLength = 0
               moEntity      = ?.
    end method.
    
    method private void AddEntity(input poEntity as Object):
        Assert:NotNull(poEntity, 'Entity').
        
        assign moEntity = poEntity.
        
        moEntityContentFilter:Add(poEntity).
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
        define variable hCredentials as handle extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cRealm as character no-undo.
        define variable oRequest as ByteBucket no-undo.
        
        assign oRequest = ByteBucket:Instance().
        
        /* REQUEST LINE */
        oRequest:PutString(substitute('&1 &2 &3~r~n',
                                this-object:Method:Name,
                                this-object:URI:RelativeURI,
                                this-object:Version      )).
        
        WriteHeader(oRequest, "Host",
                    this-object:URI:Host).
        
        /* HEADERS */
        WriteHeader(oRequest, 'User-Agent',
                    substitute('&1/&2', 
                        poHttpLibrary:LibraryName,
                        poHttpLibrary:LibraryVersion)).
        
        oIterator = GetHeaderIterator().
        do while oIterator:HasNext():
            oEntry = cast(oIterator:Next(), MapEntry).
            
            WriteHeader(oRequest,
                      oEntry:Key:ToString(), oEntry:Value:ToString()).
        end.
        
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
            ExtractMessageBody().
            
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
        if valid-object(moMessageBody) and moMessageBody:Size gt 0 then
            oRequest:PutBytes(moMessageBody).
        
        return oRequest:GetBytes().
    end method.
    
    method private void WriteHeader(input poBody as ByteBucket,
                                    input pcName as character,
                                    input pcValue as character):
        poBody:PutString(substitute('&1: &2~r~n', 
                            trim(pcName), 
                            pcValue)).
    end method.                                  
    
end class. 