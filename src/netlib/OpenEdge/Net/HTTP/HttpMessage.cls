/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HttpMessage
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 14:34:39 EST 2014
    Notes       : * Most properties mutators and associated 'set' methods are 
                    PROTECTED in this class. The ConcreteHttpResponse or HttpRequest 
                    implementations should either provide public overrides or
                    a public mutator method.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.CookieCollection.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.Filter.Writer.SetHeaderMessageWriterBuilder.
using OpenEdge.Net.HTTP.IHttpMessageWriter.

class OpenEdge.Net.HTTP.HttpMessage 
            implements IHttpMessage, ISupportInitialize
            abstract:
    
    /* Stores header name/value pairs */
    define static protected temp-table Headers no-undo
        field ParentMessage as integer
        field HeaderName as character
        field HttpHeader as Object
        index idx1 as primary unique ParentMessage HeaderName. 
    
    /** The cookies only relevant to only this message (request or response) */
    define protected property Cookies as CookieCollection no-undo get. private set.
    
    /** The HTTP version supported. Typically HTTP/1.1  */
    define public property Version as character no-undo
        get.
        set(input pcVersion as character):
            Assert:NotNullOrEmpty(pcVersion, 'Version').
            assign this-object:Version = pcVersion.
        end set.
    
    /** The message's content type (eg text/html). For more detail, see
        http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.7 */
    define public property ContentType as character no-undo
        get.
        set(input pcContentType as character):
            Assert:NotNull(pcContentType, 'Content Type').
            assign this-object:ContentType = pcContentType.
        end set.
     
    /** The message's content type encoding (eg charset='utf-8'). For more detail, see
        http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.7 */
    define public property CharacterEncoding as character no-undo
        get.
        set(input pcCharacterEncoding as character):
            Assert:NotNull(pcCharacterEncoding, 'Character Encoding').
            assign this-object:CharacterEncoding = pcCharacterEncoding.
        end set.
    
    /** Object containing the response body/entity.
        The object can be of any type, which may depend on the content type
        and the body filters it passes through. */
    define public property Entity as Object no-undo get. set.
    
    /**  The length (in bytes/characters) of the payload/entity. */    
    define public property ContentLength as integer no-undo
        get.
        set (input piContentlength as integer):
            Assert:IsZeroOrPositive(piContentlength, 'Content Length').
            assign this-object:ContentLength = piContentlength.
        end set.
    
    /** The message's Transfer-Encoding. For more detail, see
        http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6 */ 
    define public property TransferEncoding as character no-undo
        get.
        set(input pcTransferEncoding as character):
            Assert:NotNull(pcTransferEncoding, 'Transfer encoding').
            assign this-object:TransferEncoding = pcTransferEncoding.
        end set.
    
    /**  An MD5 hash of the message's content. */    
    define public property ContentMD5 as raw no-undo get. set.
        
    /** Default constructor. */
    constructor protected HttpMessage():
    end constructor.
    
    method public void Initialize():
        assign this-object:TransferEncoding = TransferEncodingEnum:None:Name
               this-object:Cookies          = new CookieCollection().
    end method.
 
    method public void Destroy():
        assign this-object:Entity = ?.
        
        ClearHeaders().
        ClearCookies().
    end method.
    
    /** Adds header info to this message's collection of headers.
        
        @param character The header name
        @param character The complete header value  */
    method public void SetHeader(input poHeader as HttpHeader):
        define variable oWriter as IHttpMessageWriter no-undo.
        Assert:NotNull(poHeader, 'Http Header').
        
        assign oWriter = SetHeaderMessageWriterBuilder:Build(this-object, poHeader).
        
        if valid-object(oWriter) then
        do:
            oWriter:Open().
            oWriter:Write(poHeader).
            oWriter:Close(). 
        end.
        else
            UpdateHeaderRecord(poHeader).
    end method.
    
    /** Internal helper method to perform the find. 
    
        @param handle    The buffer handle of the Headers table.
        @param character The header name
        @return logical True if a header record was found. */ 
    method private logical FindHeaderRecord(input phBuffer as handle, input pcName as character):
        phBuffer:find-unique(substitute('where &1.ParentMessage eq &2 and &1.HeaderName eq &3',
                               phBuffer:name,
                               integer(this-object),
                               quoter(pcName))) no-error.
        
        return phBuffer:available.
    end method.

    /** Internal helper method to perform the find. 
    
        @param character The header name
        @return logical True if a header record was found. */ 
    method private logical FindHeaderRecord(input pcName as character):
        return FindHeaderRecord(buffer Headers:handle, pcName).
    end method.
     
    /** Private method for updating the value of a header record
        
        @param character The header name
        @param character the header value. */
    method private void UpdateHeaderRecord(input poHeader as HttpHeader):
        define buffer lbHeader for Headers.
        
        find lbHeader where
             lbHeader.ParentMessage eq integer(this-object) and
             lbHeader.HeaderName eq poHeader:Name
             no-error.
        if not available lbHeader then
        do:
            create lbHeader.
            assign lbHeader.ParentMessage = integer(this-object)
                   lbHeader.HeaderName = poHeader:Name.
        end.
        assign lbHeader.HttpHeader = poHeader.
    end method.

    /** Private method for removing a header record
        
        @param character The header name  */
    method private void DeleteHeaderRecord(input pcName as character):
        define buffer lbHeader for Headers.
        
        if FindHeaderRecord(buffer lbHeader:handle, pcName) then
            delete lbHeader.
    end method.
    
    /** Returns a named header

        @param  character The name of the header to retrieve
        @return HttpHeader The header object. Null if not exists. */
    method public HttpHeader GetHeader(input pcName as character).
        define buffer lbHeader for Headers.
        
        Assert:NotNullOrEmpty(pcName, 'Header name').
        
        if FindHeaderRecord(buffer lbHeader:handle, pcName) then
            return cast(lbHeader.HttpHeader, HttpHeader).
        else
            return ?.
    end method.
    
    /** Returns all the headers (Names and values)
        
        @param HttpHeader[] An array of headers
        @return integer The number of headers returned */
    method public integer GetHeaders(output poHeaders as HttpHeader extent):
        define variable iCount as integer no-undo.
        define buffer lbHeader for Headers.
        
        define query qryHeader for lbHeader.
        open query qryHeader preselect each lbHeader where 
                                            lbHeader.ParentMessage eq integer(this-object).
        
        assign iCount = query qryHeader:num-results.
        if iCount ne 0 then
            assign extent(poHeaders) = iCount.
        
        get first qryHeader.
        do while available lbHeader:
            assign poHeaders[query qryHeader:current-result-row] = cast(lbHeader.HttpHeader, HttpHeader)
                   .
            get next qryHeader.
        end.
        
        return iCount.
        finally:
            close query qryHeader.
        end finally.
    end method.
        
    /** Indicates whether a header exists for this message or not. 
        
        @param character The name of a header to check
        @return logical True if this message contains the header */
    method public logical HasHeader(input pcName as character):
        Assert:NotNullOrEmpty(pcName, 'Header name').
        
        return FindHeaderRecord(pcName).
    end method.
    
    /** Removes a header from the collection of message headers.
        No-op if none exists.
        
        This implementation sets the value of the header to ?/unknown,
        passes it down the filter chain, and then removes it from the 
        header collection.
        
        @param character The name of the header to remove */    
    method public void RemoveHeader(input pcName as character):
        Assert:NotNullOrEmpty(pcName, 'Header name').
        
        DeleteHeaderRecord(pcName).
    end method.
    
    /** COOKIES **/
    /** Removes a cookie from this request 
    
        @param Cookie The cookie to remove. */
    method public void RemoveCookie(input poCookie as Cookie):
        Assert:NotNull(poCookie, 'Cookie').
        
        this-object:Cookies:Remove(poCookie).
    end method.
    
    /** Indicates whether a cookie exists for this message
        
        @param Cookie The cookie to check 
        @return logical True if this message contains the cookie */
    method public logical HasCookie(input poCookie as Cookie):
        Assert:NotNull(poCookie, 'Cookie').
        
        return this-object:Cookies:Contains(poCookie).
    end method.
    
    /** Returns all the cookies for this message
        
        @param Cookie[] An array of cookies 
        @return integer The number of cookies returned */
    method public integer GetCookies(output poCookies as Cookie extent):
        assign poCookies = cast(this-object:Cookies:ToArray(), Cookie).
        
        return this-object:Cookies:Size.
    end method.
    
    /** Adds a cookie to this request 
    
        @param Cookie The cookie to add. */
    method public void SetCookie(input poCookie as Cookie):
        Assert:NotNull(poCookie, 'Cookie').
        this-object:Cookies:Add(poCookie).
    end method.
    
    /** Removes all cookies from this message */ 
    method public void ClearCookies():
        this-object:Cookies:Clear().
    end method.
    
    /** Removes all headers from this message */ 
    method public void ClearHeaders().
        define buffer lbHeader for Headers.
        
        for each lbHeader where
                 lbHeader.ParentMessage eq integer(this-object):
            delete lbHeader.
        end.                     
    end method.
    
end class.