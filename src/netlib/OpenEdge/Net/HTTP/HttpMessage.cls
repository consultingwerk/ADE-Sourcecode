/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HttpMessage
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 14:34:39 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.CookieCollection.
using OpenEdge.Net.HTTP.Filter.Body.BodyFilterList.
using OpenEdge.Net.HTTP.Filter.Body.BodyFilterNode.
using OpenEdge.Net.HTTP.Filter.Body.FormDataBodyFilter.
using OpenEdge.Net.HTTP.Filter.Body.HtmlBodyFilter.
using OpenEdge.Net.HTTP.Filter.Body.JsonBodyFilter.
using OpenEdge.Net.HTTP.Filter.Body.MessageBodyFilter.
using OpenEdge.Net.HTTP.Filter.Body.XmlBodyFilter.
using OpenEdge.Net.HTTP.Filter.Header.ContentLengthHeaderFilter.
using OpenEdge.Net.HTTP.Filter.Header.ContentTypeHeaderFilter.
using OpenEdge.Net.HTTP.Filter.Header.CookieHeaderFilter.
using OpenEdge.Net.HTTP.Filter.Header.GeneralHeaderFilter.
using OpenEdge.Net.HTTP.Filter.Header.HeaderFilter.
using OpenEdge.Net.HTTP.Filter.Header.HeaderFilterList.
using OpenEdge.Net.HTTP.Filter.Header.HeaderFilterNode.
using OpenEdge.Net.HTTP.Filter.Header.TransferEncodingHeaderFilter.
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.HttpMessage abstract:
    define private variable mlSealed as logical no-undo.
    
    define protected variable moHeaderFilter as HeaderFilterList no-undo.
    define protected variable moBodyFilter as BodyFilterList no-undo.
    define protected variable moHeaders as IStringStringMap no-undo.
    
    /** The cookies only relevant to only this message (request or response) */    
    define protected variable moCookies as CookieCollection no-undo.
    
    define public property Version as character no-undo
        get.
        set(input pcVersion as character):
            CheckSeal().
            assign this-object:Version = pcVersion.
        end set.
    
    define public property ContentType as character no-undo
        get.
        set(input pcContentType as character):
            CheckSeal().
            assign this-object:ContentType = pcContentType.
        end set.
    
    /** Object containing the response body/entity.
        The object can be of any type, which may depend on the content type
        and the body filters it passes through. */
    define protected variable moEntity as Object no-undo.
    define abstract public property Entity as Object no-undo get.
    
    /** Memptr containing the message body/entity for passing to the request
        or response. */
    define protected variable moMessageBody as class ByteBucket no-undo.
    define public property MessageBody as class ByteBucket no-undo get. protected set.
    
    define public property ContentLength as integer no-undo
        get. 
        set(input piContentLength as integer):
            CheckSeal().
            assign this-object:ContentLength = piContentLength.
        end set.
 
     define public property ContentTypeEncoding as character no-undo
        get.
        set(input pcContentTypeEncoding as character):
            CheckSeal().
            assign this-object:ContentTypeEncoding = pcContentTypeEncoding.
        end set.

    define public property TransferEncoding as TransferEncodingEnum no-undo
        get.
        set(input poTransferEncoding as TransferEncodingEnum):
            CheckSeal().
            assign this-object:TransferEncoding = poTransferEncoding.
        end set.
    
    method public void Initialize():
        assign this-object:TransferEncoding = TransferEncodingEnum:None
               moHeaders = new StringStringMap()
               moCookies = new CookieCollection()
               mlSealed  =  false
               moBodyFilter   = new BodyFilterList()
               moHeaderFilter = new HeaderFilterList().
        
        /* Header filters */
        InitializeHeaderFilters().
        
        /* Body filters */
        InitializeBodyFilters().
    end method.
 
    method public void Destroy():
        RemoveHeaderFilter().
        RemoveBodyFilter().
        
        assign moEntity = ?
               moHeaders = ?
               moCookies = ?.
    end method.
        
    /* BODY FILTERS */
    method protected void InitializeBodyFilters(): 
        AddBodyFilter(new JsonBodyFilter(this-object)).
        AddBodyFilter(new FormDataBodyFilter(this-object)).
        AddBodyFilter(new XmlBodyFilter(this-object)).
        AddBodyFilter(new HtmlBodyFilter(this-object)).
    end method.
    
    method protected void InitializeHeaderFilters():
        AddHeaderFilter(new ContentTypeHeaderFilter(this-object)).
        AddHeaderFilter(new ContentLengthHeaderFilter(this-object)).
        AddHeaderFilter(new CookieHeaderFilter(this-object)).
        AddHeaderFilter(new TransferEncodingHeaderFilter(this-object)).
        AddHeaderFilter(new GeneralHeaderFilter(this-object)).
    end method.
    
    method protected void AddBodyFilter(input poFilter as MessageBodyFilter):
        Assert:NotNull(poFilter, 'Body filter').
        Assert:NotNull(moBodyFilter, 'Body filter list').
        
        moBodyFilter:InsertLast(new BodyFilterNode(poFilter)).
    end method.
    
    method protected void RemoveBodyFilter():
        assign moBodyFilter = ?.
    end method.
    
    /* HEADERS &  FILTERS */
    method protected void AddHeaderFilter(input poFilter as HeaderFilter):
        Assert:NotNull(poFilter, 'Header filter').
        Assert:NotNull(moHeaderFilter, 'Header filter list').
        moHeaderFilter:InsertLast(new HeaderFilterNode(poFilter)).
    end method.
    
    method protected void RemoveHeaderFilter():
        assign moHeaderFilter = ?.
    end method.
    
    /** Adds header info to this message's collection of headers. This is 
        the correct method in the HttpMessage class to call for adding headers,
        since it passes the new header into the filter chain to be processed.
        
        @param character The header name
        @param character The complete header value  */
    method public void AddHeader(input pcName as character, input pcValue as character):
        CheckSeal().
        
        moHeaderFilter:Add(pcName, pcValue).
    end method.
    
    method public longchar GetHeaderEntry(input pcName as character):
        return moHeaders:Get(pcName).
    end method.
    
    /** Adds header info to this message's collection of headers. Should only be 
        called from a GeneralHeaderFilter or a similar descendant of HeaderFilter.
        
        The correct method in the HttpMessage class to call is AddHeader(), which
        passes the new header into the filter chain to be processed.
        
        @param character The header name
        @param character The complete header value  */
    method public void SetHeaderEntry(input pcName as character, input pcValue as character):
        CheckSeal().
        moHeaders:Put(pcName, pcValue).
    end method.
    
    method public void RemoveHeaderEntry(input pcName as character):
        CheckSeal().
        moHeaders:Remove(pcName).
    end method.    
    
    method public void RemoveHeader(input pcName as character):
        CheckSeal().        
        moHeaderFilter:Remove(pcName).    
    end method.
    
    method public IIterator GetHeaderIterator():
        return moHeaders:EntrySet:Iterator().
    end method. 
    
    /** COOKIES AND FILTERS **/
    method public void SetCookieEntry(input poCookie as Cookie):
        CheckSeal().
        
        Assert:NotNull(poCookie, 'Cookie').                        
        moCookies:Add(poCookie).
    end method.
    
    method public IIterator GetCookiesIterator():
        return moCookies:Iterator().
    end method.
    
    method public void AddCookies(input poCookies as CookieCollection):
        CheckSeal().
        Assert:NotNull(poCookies, 'Cookies').
        
        if moCookies:IsEmpty() then
            assign moCookies = poCookies.
        else
            moCookies:AddAll(poCookies).
    end method.
    
    method public void ClearCookies():
        CheckSeal().
        moCookies:Clear().
    end method.
    
    method protected void CheckSeal():
        if mlSealed then
            undo, throw new AppError(
                    substitute('&1 sealed: read-only access',
                                entry(num-entries(this-object:GetClass():TypeName, '.'), this-object:GetClass():TypeName, '.')),
                     0).
    end method.
 
     method public void Seal():
        Assert:NotNullOrEmpty(this-object:Version, 'Version').
        Assert:NotNull(moHeaders, 'Headers').
        
        assign mlSealed = true.
    end method.
    
    method protected void ExtractEntity():
        moBodyFilter:Extract(input-output moEntity).
    end method.
    
    method protected void ExtractMessageBody():
        moBodyFilter:Insert(input-output moMessageBody).
    end method.
    
end class.