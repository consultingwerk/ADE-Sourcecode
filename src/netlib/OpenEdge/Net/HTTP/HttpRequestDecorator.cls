/************************************************
Copyright (c) 2015-2016, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HttpRequestDecorator
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
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.URI.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.HttpRequestDecorator 
            implements IHttpRequest, IAdaptable: 
    
    /* the decorated Request. this can be a decoration or an actual http Request */
    define protected property DecoratedHttpRequest as IHttpRequest no-undo get. private set.
    
    define public property Method as character no-undo 
       get():
           return DecoratedHttpRequest:Method.
       end get.
       set(input pcMethod as character):
           DecoratedHttpRequest:Method = pcMethod.
       end set.

    define public property URI as URI no-undo 
       get():
           return DecoratedHttpRequest:URI.
       end get.
       set(input poURI as URI):
           DecoratedHttpRequest:URI = poURI.
       end set.

    define public property Version as character no-undo 
        get():
            return DecoratedHttpRequest:Version.
        end get.
        set(input pcVersion as character):
            DecoratedHttpRequest:Version = pcVersion.
        end set.

    define public property ContentType as character no-undo 
        get():
            return DecoratedHttpRequest:ContentType.
        end get.
        set(input pcContentType as character):
            DecoratedHttpRequest:ContentType = pcContentType.
        end set.

    define public property CharacterEncoding as character no-undo 
        get():
            return DecoratedHttpRequest:CharacterEncoding.
        end get.
        set(input pcCharacterEncoding as character):
            DecoratedHttpRequest:CharacterEncoding = pcCharacterEncoding.
        end set.

    define public property ContentMD5 as raw no-undo 
        get():
            return DecoratedHttpRequest:ContentMD5.
        end get.
        set(input prContentMD5 as raw):
            DecoratedHttpRequest:ContentMD5 = prContentMD5.
        end set.

    define public property Entity as Object no-undo 
        get():
            return DecoratedHttpRequest:Entity.        
        end get.
        set(input poEntity as Object):
            DecoratedHttpRequest:Entity = poEntity.
        end set.
    
    define public property ContentLength as integer no-undo 
        get():
            return DecoratedHttpRequest:ContentLength.
        end get.
        set(input piContentLength as integer):
            DecoratedHttpRequest:ContentLength = piContentLength.
        end set.

    define public property TransferEncoding as character no-undo 
        get():
            return DecoratedHttpRequest:TransferEncoding.
        end get.
        set(input pcTransferEncoding as character):
            DecoratedHttpRequest:TransferEncoding = pcTransferEncoding.
        end set.
     
    constructor public HttpRequestDecorator(input poHttpRequest as IHttpRequest):
        Assert:NotNull(poHttpRequest, 'HttpRequest').
        assign DecoratedHttpRequest = poHttpRequest.
    end constructor.       
    
    method public void SetHeader( input poHeader as HttpHeader ):
        DecoratedHttpRequest:SetHeader(poHeader).
    end method.
    
    /** Adds a set of header info to this message's collection of headers.
        
        @param HttpHeader[] An array of headers */
    method public void SetHeaders(input poHeader as HttpHeader extent):
        DecoratedHttpRequest:SetHeaders(poHeader).
    end method.
    
    method public HttpHeader GetHeader( input pcName as character ):
        return DecoratedHttpRequest:GetHeader(pcName).
    end method.

    method public integer GetHeaders(output poHeader as HttpHeader extent ):
        return DecoratedHttpRequest:GetHeaders(output poHeader).
    end method.

    method public void RemoveHeader( input pcName as character ):
        DecoratedHttpRequest:RemoveHeader(pcName).
    end method.

    method public logical HasHeader( input pcName as character ):
        return DecoratedHttpRequest:HasHeader(pcName).
    end method.

    method public void ClearHeaders():
        DecoratedHttpRequest:ClearHeaders().
    end method.

    method public void SetCookie( input poCookie as OpenEdge.Net.HTTP.Cookie ):
        DecoratedHttpRequest:SetCookie(poCookie).
    end method.
    
    /** Adds cookies to this message
        
        @param Cookie[] An array of cookies to add. */
    method public void SetCookies(input poCookies as Cookie extent):
        DecoratedHttpRequest:SetCookies(poCookies).
    end method.
    
    method public integer GetCookies( output poCookies as Cookie extent):
        return     DecoratedHttpRequest:GetCookies(output poCookies).
    end method.

    method public void RemoveCookie( input poCookie as Cookie):
        DecoratedHttpRequest:RemoveCookie(poCookie).
    end method.

    method public logical HasCookie( input poCookie as Cookie):
        return DecoratedHttpRequest:HasCookie(poCookie).
    end method.

    method public void ClearCookies():
        DecoratedHttpRequest:ClearCookies().
    end method.

    method public void RemoveCookie( input pcName as character ):
        DecoratedHttpRequest:RemoveCookie(pcName).
    end method.

    method public logical HasCookie( input pcName as character ):
        return DecoratedHttpRequest:HasCookie(pcName).
    end method.

    method public Cookie GetCookie( input pcName as character ):
        return DecoratedHttpRequest:GetCookie(pcName).
    end method.
    
    /* Returns an adapter for this message 
       
       @param P.L.Class The type we want to adapt this message to
       @return P.L.Object The adapter. Will typically be of the type specified by the input argument */
    method public Progress.Lang.Object GetAdapter(input poAdaptTo as class Progress.Lang.Class):
        Assert:NotNull(poAdaptTo, 'Adapter').
        
        if this-object:GetClass():IsA(poAdaptTo) then
            return this-object.
        
        if valid-object(DecoratedHttpRequest) and
           type-of(DecoratedHttpRequest, IAdaptable) then
            return cast(DecoratedHttpRequest, IAdaptable):GetAdapter(poAdaptTo).
        
        return ?.            
    end method.
    
end class.