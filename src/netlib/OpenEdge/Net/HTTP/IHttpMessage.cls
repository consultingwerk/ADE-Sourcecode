/************************************************
Copyright (c) 2015, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : IHttpMessage
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 22 15:31:36 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.HttpHeader.
using Progress.Lang.Object.

interface OpenEdge.Net.HTTP.IHttpMessage:
    
    /** The HTTP version supported. Typically HTTP/1.1  */
    define public property Version as character no-undo get. set.
    
    /** The message's content type (eg text/html). For more detail, see
        http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.7 */
    define public property ContentType as character no-undo get. set.
    
    /** The message's content type encoding (eg charset='utf-8'). For more detail, see
        http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.7 */
    define public property CharacterEncoding as character no-undo get. set.
    
    /**  An MD5 hash of the message's content. */    
    define public property ContentMD5 as raw no-undo get. set.
    
    /** Object containing the message body/entity. The object can be of any type,
        which may depend on the content type.
        
        The Entity is the 'programmer-readable' version of the message body: it's 
        the formatted, strongly-typed version */
    define public property Entity as Object no-undo get. set.
    
    /**  The length (in bytes/characters) of the payload/entity. */    
    define public property ContentLength as integer no-undo get. set.
    
    /** The message's Transfer-Encoding. For more detail, see
        http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6 */  
    define public property TransferEncoding as character no-undo get. set.
    
    /** Adds header info to this message's collection of headers.
        
        @param HttpHeader The header */
    method public void SetHeader(input poHeader as HttpHeader).
    
    /** Adds a set of header info to this message's collection of headers.
        
        @param HttpHeader[] An array of headers */
    method public void SetHeaders(input poHeader as HttpHeader extent).
    
    /** Returns all the headers

        @param HttpHeader[] An array of headers
        @return integer The number of headers returned */
    method public integer GetHeaders(output poHeaders as HttpHeader extent).
    
    /** Returns a named header

        @param  character The name of the header to retrieve
        @return HttpHeader The header object. Null if not exists. */
    method public HttpHeader GetHeader(input pcName as character).
    
    /** Removes all headers with a given name from the set of message headers.
        No-op if none exists.
                
        @param character The name of the header to remove */    
    method public void RemoveHeader(input pcName as character).
    
    /** Indicates whether a header exists for this message or not. 
        
        @param character The name of a header to check
        @return logical True if this message contains the header */
    method public logical HasHeader(input pcName as character).
    
    /** Removes all headers from this message */ 
    method public void ClearHeaders().

    /** Adds a cookie to this message
        
        @param Cookie The cookie to add. */
    method public void SetCookie(input poCookie as Cookie).
    
    /** Adds cookies to this message
        
        @param Cookie[] An array of cookies to add. */
    method public void SetCookies(input poCookies as Cookie extent).
    
    /** Returns all the cookies for this message
        
        @param Cookie[] An array of cookies 
        @return integer The number of cookies returned */
    method public integer GetCookies(output poCookies as Cookie extent).
    
    /** Removes a cookie from this message
    
        @param Cookie The cookie to remove. */
    method public void RemoveCookie(input poCookie as Cookie).    

    /** Removes coolies from this message for a given name
    
        @param character The name of the cookie(s) to remove. */
    method public void RemoveCookie(input pcName as character ).    

    /** Indicates whether a cookie exists for this message
        
        @param Cookie The cookie to check 
        @return logical True if this message contains the cookie */
    method public logical HasCookie(input poCookie as Cookie).
    
    /** Indicates whether a cookie exists for this message
        
        @param character The cookie's name to check 
        @return logical TRUE if this message contains the cookie */
    method public logical HasCookie(input pcName as character).
    
    /** Returns a cookie by name from this message. Typically
        returns the first cookie it finds by name, oif more than
        one exist 
        
        @param character The cookie's name to check 
        @return Cookie The (first) cookie found by name */
    method public Cookie GetCookie(input pcName as character).
    
    /** Removes all cookies from this message */ 
    method public void ClearCookies().
    
end interface.
