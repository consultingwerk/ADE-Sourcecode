/************************************************
Copyright (c) 2015-2016, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HttpResponseDecorator
    Purpose     : Decorator class for decorating/customising Http Requests
                  without requiring inheritance. This allows us to construct 
                  more complex Requests (say with proxy OR with credentials,
                  no proxy) without having to have individual types for all the 
                  combinations                  
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jan 28 16:19:09 EST 2015
    Notes       : * There's a decent description of Decorator pattern in Wikipedia
                    at http://en.wikipedia.org/wiki/Decorator_pattern
                  * This class should be extended to provide specific functionality.
                    For instance, adding support for proxies, or cookies 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.IAdaptable.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.IHttpResponse.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.HttpResponseDecorator implements IHttpResponse, IAdaptable: 
    
    /* the decorated Request. this can be a decoration or an actual http Request */
    define protected property DecoratedHttpResponse as IHttpResponse no-undo get. private set.
    
    /** The status of the HTTP response. Section 6.1 */
    define public property StatusCode as integer no-undo 
        get():
            return DecoratedHttpResponse:StatusCode.
        end get.
        set(input piStatusCode as integer):
            assign DecoratedHttpResponse:StatusCode = piStatusCode.
        end set.    
    /** The status reason of the HTTP response. Section 6.1 */
    define public property StatusReason as character no-undo
        get():
            return DecoratedHttpResponse:StatusReason.
        end get.
        set(input pcStatusReason as character):
            assign DecoratedHttpResponse:StatusReason = pcStatusReason.
        end set.
        
    define public property Version as character no-undo 
        get():
            return DecoratedHttpResponse:Version.
        end get.
        set(input pcVersion as character):
            DecoratedHttpResponse:Version = pcVersion.
        end set.

    define public property ContentType as character no-undo 
        get():
            return DecoratedHttpResponse:ContentType.
        end get.
        set(input pcContentType as character):
            DecoratedHttpResponse:ContentType = pcContentType.
        end set.

    define public property CharacterEncoding as character no-undo 
        get():
            return DecoratedHttpResponse:CharacterEncoding.
        end get.
        set(input pcCharacterEncoding as character):
            DecoratedHttpResponse:CharacterEncoding = pcCharacterEncoding.
        end set.

    define public property ContentMD5 as raw no-undo 
        get():
            return DecoratedHttpResponse:ContentMD5.
        end get.
        set(input prContentMD5 as raw):
            DecoratedHttpResponse:ContentMD5 = prContentMD5.
        end set.

    define public property Entity as Object no-undo 
        get():
            return DecoratedHttpResponse:Entity.     
        end get.
        set(input poEntity as Object):
            DecoratedHttpResponse:Entity = poEntity.
        end set.
    
    define public property ContentLength as integer no-undo 
        get():
            return DecoratedHttpResponse:ContentLength.
        end get.
        set(input piContentLength as integer):
            DecoratedHttpResponse:ContentLength = piContentLength.
        end set.

    define public property TransferEncoding as character no-undo 
        get():
            return DecoratedHttpResponse:TransferEncoding.
        end get.
        set(input pcTransferEncoding as character):
            DecoratedHttpResponse:TransferEncoding = pcTransferEncoding.
        end set.
     
    constructor public HttpResponseDecorator(input poHttpResponse as IHttpResponse):
        Assert:NotNull(poHttpResponse, 'HttpResponse').
        assign DecoratedHttpResponse = poHttpResponse.
    end constructor.       

    method public void SetHeader( input poHeader as HttpHeader):
        DecoratedHttpResponse:SetHeader(poHeader).
    end method.
    
    /** Adds a set of header info to this message's collection of headers.
        
        @param HttpHeader[] An array of headers */
    method public void SetHeaders(input poHeader as HttpHeader extent):
        DecoratedHttpResponse:SetHeaders(poHeader).
    end method.

    method public HttpHeader GetHeader( input pcName as character ):
        return DecoratedHttpResponse:GetHeader(pcName).
    end method.

    method public integer GetHeaders( output poHeader as HttpHeader extent ):
        return DecoratedHttpResponse:GetHeaders(output poHeader).
    end method.

    method public void RemoveHeader( input pcName as character ):
        DecoratedHttpResponse:RemoveHeader(pcName).
    end method.

    method public logical HasHeader( input pcName as character ):
        return DecoratedHttpResponse:HasHeader(pcName).
    end method.

    method public void ClearHeaders():
        DecoratedHttpResponse:ClearHeaders().
    end method.

    method public void SetCookie( input poCookie as OpenEdge.Net.HTTP.Cookie ):
        DecoratedHttpResponse:SetCookie(poCookie).
    end method.
    
    /** Adds cookies to this message
        
        @param Cookie[] An array of cookies to add. */
    method public void SetCookies(input poCookies as Cookie extent):
        DecoratedHttpResponse:SetCookies(poCookies).
    end method.

    method public integer GetCookies( output poCookies as Cookie extent):
        return  DecoratedHttpResponse:GetCookies(output poCookies).
    end method.

    method public void RemoveCookie( input poCookie as Cookie):
        DecoratedHttpResponse:RemoveCookie(poCookie).
    end method.

    method public logical HasCookie( input poCookie as Cookie):
        return DecoratedHttpResponse:HasCookie(poCookie).
    end method.

    method public void ClearCookies():
        DecoratedHttpResponse:ClearCookies().
    end method.

    method public void RemoveCookie( input pcName as character ):
        DecoratedHttpResponse:RemoveCookie(pcName).
    end method.

    method public logical HasCookie( input pcName as character ):
        return DecoratedHttpResponse:HasCookie(pcName).
    end method.

    method public Cookie GetCookie( input pcName as character ):
        return DecoratedHttpResponse:GetCookie(pcName).
    end method.
    
    /* Returns an adapter for this message 
       
       @param P.L.Class The type we want to adapt this message to
       @return P.L.Object The adapter. Will typically be of the type specified by the input argument */
    method public Progress.Lang.Object GetAdapter(input poAdaptTo as class Progress.Lang.Class):
        Assert:NotNull(poAdaptTo, 'Adapter').
        
        if this-object:GetClass():IsA(poAdaptTo) then
            return this-object.
        
        if valid-object(DecoratedHttpResponse) and
           type-of(DecoratedHttpResponse, IAdaptable) then
            return cast(DecoratedHttpResponse, IAdaptable):GetAdapter(poAdaptTo).
        
        return ?.            
    end method.    
end class.