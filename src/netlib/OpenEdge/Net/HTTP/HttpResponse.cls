/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HttpResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 18 13:24:08 EST 2013
    Notes       : * Via http://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html 
                  Response      = Status-Line               ; Section 6.1
                                       *(( general-header        ; Section 4.5
                                        | response-header        ; Section 6.2
                                        | entity-header ) CRLF)  ; Section 7.1
                                       CRLF
                                       [ message-Entity ]          ; Section 7.2
                http://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html
                
                Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF                                                
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.ConcreteHttpResponse.
using OpenEdge.Net.HTTP.Filter.Message.MessageFilterList.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.Filter.Header.ContentEncodingHeaderFilter.
using OpenEdge.Net.HTTP.Filter.Payload.JsonExtractBodyFilter.
using OpenEdge.Net.HTTP.Filter.Payload.HtmlExtractBodyFilter.
using OpenEdge.Net.HTTP.Filter.Payload.DefaultExtractBodyFilter.
using OpenEdge.Net.HTTP.Filter.Payload.XmlExtractBodyFilter.

class OpenEdge.Net.HTTP.HttpResponse inherits HttpMessage
        abstract:
    /* Holds filters for creating an entity from a message body */
    define private variable moExtractBodyFilters as MessageFilterList no-undo.
    
    define public property StatusCode as StatusCodeEnum no-undo
        get.
        set(input poStatusCode as StatusCodeEnum):
            CheckSeal().
            Assert:NotNull(poStatusCode, 'Status Code').
            this-object:StatusCode = poStatusCode.
        end set.
    
    define public property StatusReason as character no-undo
        get.
        set(input pcStatusReason as character):
            CheckSeal().
            this-object:StatusReason = pcStatusReason.
        end set.
    
    /** Object containing the response body/entity.
        The object can be of any type, which may depend on the content type
        and the body filters it passes through. */
    define override public property Entity as Object no-undo
        get():
            /* lazy load, if there's data */
            if not valid-object(this-object:Entity) then
                this-object:PopulateEntity().
            return this-object:Entity.
        end get.
        set.
    
    define public property ContentEncoding as TransferEncodingEnum no-undo
        get.
        set(input poContentEncoding as TransferEncodingEnum):
            CheckSeal().
            assign this-object:ContentEncoding = poContentEncoding.
        end set.
    
    /** (mandatory) The Request that this object is in response to. */
    define public property Request as HttpRequest no-undo get. private set.
    
    constructor public HttpResponse(input poRequest as HttpRequest):
        Assert:NotNull(poRequest, 'Request').
        this-object:Request = poRequest.
    end constructor.
    
    /** Factory method to create a new response object. */
    method static public HttpResponse Instance(input poRequest as HttpRequest):
        define variable oResponse as HttpResponse no-undo.
        
        oResponse = new ConcreteHttpResponse(poRequest).
        oResponse:Initialize().
        
        return oResponse.
    end method.
    
	method override public void Destroy(  ):
		super:Destroy().
		
        DestroyBodyFilters().
	end method.
	
	method override public void Initialize(  ):
		super:Initialize().

        InitializeBodyFilters().
	end method.    
            
    method override protected void InitializeHeaderFilters():
        super:InitializeHeaderFilters().
        
        AddHeaderFilter(this-object:HeaderFilters, 
                        get-class(ContentEncodingHeaderFilter)).
    end method.
    
    method protected void InitializeBodyFilters(): 
        moExtractBodyFilters = new MessageFilterList().
        
        AddMessageFilter(moExtractBodyFilters, get-class(JsonExtractBodyFilter)).
        AddMessageFilter(moExtractBodyFilters, get-class(HtmlExtractBodyFilter)).
        AddMessageFilter(moExtractBodyFilters, get-class(XmlExtractBodyFilter)).
        AddMessageFilter(moExtractBodyFilters, get-class(DefaultExtractBodyFilter)).
    end method.
    
    method protected void DestroyBodyFilters():
        assign moExtractBodyFilters = ?.
    end method.
    
    method override public void Seal():
        Assert:NotNull(this-object:StatusCode, 'Status').
        Assert:NotNull(this-object:Request, 'Request').
        
        super:Seal().
    end method.
    
    method protected void PopulateEntity():
        /* We can only be sure that there's a complete message
           body once the response has been sealed. */
        if this-object:Sealed then
            moExtractBodyFilters:Filter(this-object).
    end method.

end class.