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
using OpenEdge.Core.ByteBucket.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.HttpResponse inherits HttpMessage:
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
            if not valid-object(moEntity) then
                this-object:ExtractEntity().
            return moEntity.
        end get.
    
    /** (mandatory) The Request that this object is in response to. */
    define public property Request as HttpRequest no-undo get. private set.
    
    constructor public HttpResponse(input poRequest as HttpRequest):
        Assert:NotNull(poRequest, 'Request').
        this-object:Request = poRequest.
    end constructor.
    
    method static public HttpResponse Instance(input poRequest as HttpRequest):
        define variable oResponse as HttpResponse no-undo.
        
        oResponse = new HttpResponse(poRequest).
        oResponse:Initialize().
        
        return oResponse.
    end method.
    
    method override public void Seal():
        Assert:NotNull(this-object:StatusCode, 'Status').
        Assert:NotNull(this-object:Request, 'Request').
        
        super:Seal().
    end method.
    
    method public void AddMessageBody(input piCapacity as int64):
        CheckSeal().
        Assert:IsPositive(piCapacity, 'Capacity').
        
        this-object:MessageBody = ByteBucket:Instance(piCapacity).
    end method.
    
    method public void AddMessageBody(input poBody as ByteBucket):
        CheckSeal().
        Assert:NotNull(poBody, 'Message Body').
        
        this-object:MessageBody = poBody.
    end method.

    method public void AddMessageBody():
        CheckSeal().
        
        this-object:MessageBody = ByteBucket:Instance().
    end method.
        
    method public void RemoveMessageBody():
        CheckSeal().
        
        assign this-object:MessageBody = ?
               this-object:ContentLength = 0.
    end method.
end class.