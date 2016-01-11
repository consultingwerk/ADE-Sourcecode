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
using OpenEdge.Net.HTTP.Filter.Header.HeaderFilterList.
using OpenEdge.Net.HTTP.Filter.Header.HeaderFilterNode.
using OpenEdge.Net.HTTP.Filter.Header.IHeaderFilter.
using OpenEdge.Net.HTTP.Filter.Message.IMessageFilter.
using OpenEdge.Net.HTTP.Filter.Message.MessageFilterList.
using OpenEdge.Net.HTTP.Filter.Message.MessageFilterNode.
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using Progress.Lang.AppError.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.Filter.Header.ContentTypeHeaderFilter.
using OpenEdge.Net.HTTP.Filter.Header.ContentLengthHeaderFilter.
using OpenEdge.Net.HTTP.Filter.Header.TransferEncodingHeaderFilter.
using OpenEdge.Net.HTTP.Filter.Header.CookieHeaderFilter.
using OpenEdge.Net.HTTP.Filter.Header.GeneralHeaderFilter.

class OpenEdge.Net.HTTP.HttpMessage abstract:
    define protected property Sealed as logical no-undo get. private set.
    
    /* Holds filters for processing headers */
    define protected property HeaderFilters as HeaderFilterList no-undo get. private set.
    
    /* Stores header name/value pairs */
    define protected property Headers as IStringStringMap no-undo get. private set.
    
    /** The cookies only relevant to only this message (request or response) */    
    define protected property Cookies as CookieCollection no-undo get. private set.
    
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
    define abstract public property Entity as Object no-undo get. protected set.
    
    /** ByteBucket containing the message body/entity for passing to the request
        or response. */
    define abstract protected property MessageBody as ByteBucket no-undo get. set.
    
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
               this-object:Headers = new StringStringMap()
               this-object:Cookies = new CookieCollection()
               this-object:Sealed  =  false.
        
        /* Header filters */
        InitializeHeaderFilters().
    end method.
 
    method public void Destroy():
        DestroyHeaderFilters().
        
        assign this-object:Entity = ?
               this-object:Headers = ?
               this-object:Cookies = ?.
        if valid-object(MessageBody) then
            MessageBody:Clear().
    end method.
    
    /* BODY FILTERS */
    method protected void InitializeHeaderFilters():
        this-object:HeaderFilters = new HeaderFilterList().
        
        AddHeaderFilter(this-object:HeaderFilters, get-class(ContentTypeHeaderFilter)).
        AddHeaderFilter(this-object:HeaderFilters, get-class(ContentLengthHeaderFilter)).
        AddHeaderFilter(this-object:HeaderFilters, get-class(TransferEncodingHeaderFilter)).
        AddHeaderFilter(this-object:HeaderFilters, get-class(CookieHeaderFilter)).
        AddHeaderFilter(this-object:HeaderFilters, get-class(GeneralHeaderFilter)).
    end method.
    
    
    /* HEADERS &  FILTERS */
    method protected void AddHeaderFilter(input poFilterList as HeaderFilterList,
                                          input poFilterType as class Progress.Lang.Class):
        define variable oFilter as IHeaderFilter no-undo.
        
        Assert:NotNull(poFilterList, 'Header filter list').
        assign oFilter = poFilterList:GetFilterInstance(poFilterType).
        
        Assert:NotNull(oFilter, 'Header filter').
        
        poFilterList:InsertLast(new HeaderFilterNode(oFilter)).
    end method.
    
    method protected void AddMessageFilter(input poFilterList as MessageFilterList,
                                           input poFilterType as class Progress.Lang.Class):
        define variable oFilter as IMessageFilter no-undo.
        
        Assert:NotNull(poFilterList, 'Message filter list').
        assign oFilter = poFilterList:GetFilterInstance(poFilterType).
        
        Assert:NotNull(oFilter, 'Message filter').
        poFilterList:InsertLast(new MessageFilterNode(oFilter)).
    end method.
    
    method protected void DestroyHeaderFilters():
        assign this-object:HeaderFilters = ?.
    end method.
    
    /** Adds header info to this message's collection of headers. This is 
        the correct method in the HttpMessage class to call for adding headers,
        since it passes the new header into the filter chain to be processed.
        
        @param character The header name
        @param character The complete header value  */
    method public void AddHeader(input pcName as character, input pcValue as character):
        CheckSeal().
                
        this-object:HeaderFilters:Filter(pcName, pcValue, this-object).
    end method.
    
    method public longchar GetHeaderEntry(input pcName as character):
        return this-object:Headers:Get(pcName).
    end method.
    
    /** Adds header info to this message's collection of headers. Should only be 
        called from a GeneralHeaderFilter or a similar descendant of HeaderFilter.
        
        The correct method in the HttpMessage class to call is AddHeader(), which
        passes the new header into the filter chain to be processed.
        
        @param character The header name
        @param character The complete header value  */
    method public void SetHeaderEntry(input pcName as character, input pcValue as character):
        CheckSeal().
        this-object:Headers:Put(pcName, pcValue).
    end method.
    
    method public void RemoveHeaderEntry(input pcName as character):
        CheckSeal().
        if this-object:Headers:ContainsKey(pcName) then
            this-object:Headers:Remove(pcName).
    end method.    
    
    method public void RemoveHeader(input pcName as character):
        CheckSeal().
        
        this-object:HeaderFilters:Filter(pcName, ?, this-object).    
    end method.
    
    method public IIterator GetHeaderIterator():
        return this-object:Headers:EntrySet:Iterator().
    end method.
    
    /** COOKIES AND FILTERS **/
    method public void SetCookieEntry(input poCookie as Cookie):
        CheckSeal().
        
        Assert:NotNull(poCookie, 'Cookie').
        this-object:Cookies:Add(poCookie).
    end method.

    method public void RemoveCookieEntry(input poCookie as Cookie):
        CheckSeal().
        
        Assert:NotNull(poCookie, 'Cookie').
        this-object:Cookies:Remove(poCookie).
    end method.
    
    method public IIterator GetCookiesIterator():
        return this-object:Cookies:Iterator().
    end method.
    
    method public void AddCookies(input poCookies as CookieCollection):
        CheckSeal().
        Assert:NotNull(poCookies, 'Cookies').
        
        if this-object:Cookies:IsEmpty() then
            assign this-object:Cookies = poCookies.
        else
            this-object:Cookies:AddAll(poCookies).
    end method.
    
    method public void ClearCookies():
        CheckSeal().
        this-object:Cookies:Clear().
    end method.
    
    method protected void CheckSeal():
        if this-object:Sealed then
            undo, throw new AppError(
                    substitute('&1 sealed: read-only access',
                                entry(num-entries(this-object:GetClass():TypeName, '.'), this-object:GetClass():TypeName, '.')),
                     0).
    end method.
 
    method public void Seal():
        Assert:NotNullOrEmpty(this-object:Version, 'Version').
        Assert:NotNull(this-object:Headers, 'Headers').
        
        assign this-object:Sealed = true.
    end method.
    
end class.