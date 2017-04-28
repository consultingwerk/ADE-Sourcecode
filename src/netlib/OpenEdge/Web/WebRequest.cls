/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/  
/*------------------------------------------------------------------------
   Purpose     : An HttpRequest that adds request context information
   Syntax      : 
   Description : 
   Author(s)   : mbanks
   Created     : Fri Apr 24 14:07:54 EDT 2015
   Notes       : The assumption is that this is created on each web request
                 DO NOT KEEP ALIVE BETWEEN REQUESTS.
   @since      : 11.6    
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert from propath.
using OpenEdge.Core.Memptr. 
using OpenEdge.Core.Collections.IStringStringMap from propath.
using OpenEdge.Core.Collections.StringStringMap from propath.
using OpenEdge.Core.WidgetHandle from propath.
using OpenEdge.Net.HTTP.Cookie from propath.
using OpenEdge.Net.HTTP.HttpHeader from propath.
using OpenEdge.Net.URI from propath.
using OpenEdge.Web.IWebRequest from propath.
using Progress.Json.ObjectModel.ObjectModelParser from propath.
using Progress.Lang.AppError from propath.
using Progress.Lang.Object from propath.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.

class OpenEdge.Web.WebRequest implements IWebRequest: 
    define private variable mUri as URI no-undo.
    define private variable mCookies as Cookie extent  no-undo.
   
    define private variable BaseReadOnlyMessage as character no-undo 
        init "&1.&2 property is read-only". 
    
    define private variable BaseNotImplementedMessage as character no-undo 
        init "&1.&2 &3 is not implemented". 
       
    /** The HTTP version supported. Typically HTTP/1.1  */
    define public property Version as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "SERVER_PROTOCOL":U).
        end get.
        set(cProp as char):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.
    
    /** The message's content type (eg text/html). For more detail, see
        http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.7 */
    define public property ContentType as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "CONTENT_TYPE":U).
        end get.
        set(cProp as char):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.
    
    /** The message's content type encoding (eg charset='utf-8'). For more detail, see
        http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.7 */
    define public property CharacterEncoding as character no-undo 
        get():
            return web-context:get-cgi-value("ENV":U, "CHARACTER_ENCODING":U).
        end get. 
        set(cProp as char):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.
  
    /**  An MD5 hash of the message's content. */
    define public property ContentMD5 as raw no-undo 
        get():
            if length(this-object:ContentMD5) eq 0 then
                assign this-object:ContentMD5 = md5-digest(web-context:form-long-input). 
            
            return this-object:ContentMD5.
        end. 
        set(cval as raw):
            undo, throw new AppError(GetPropNotImplementedMessage(),?).
        end.
    
    /** Object containing the message body/entity. The object can be of any type,
        which may depend on the content type.
        
        The Entity is the 'programmer-readable' version of the message body: it's 
        the formatted, strongly-typed version */
    define public property Entity as Object no-undo 
        get():
            define variable parser as ObjectModelParser no-undo.
            if web-context:is-xml then
            do:
                return new WidgetHandle(web-context:x-document).
            end.    
            else if web-context:is-json then
            do:
                parser = new ObjectModelParser().
                return parser:parse(web-context).        
            end.  
            else do:
                 /* ideally this should use one of the content-type writers to get a real type */
                return new Memptr(web-context:form-long-input).
            end.
        end. 
        set(prop as Object):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.
        
    /**  The length (in bytes/characters) of the payload/entity. */    
    define public property ContentLength as integer no-undo
        get():
            return integer(web-context:get-cgi-value("ENV":U, "CONTENT_LENGTH":U)).
        end get.
        set(iProp as int):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.

    /** Returns the default cookie path   */
    define public property DefaultCookiePath as character no-undo 
        get():
             return web-context:get-cgi-value("ENV":U, "SERVLET_DEFAULT_COOKIE_PATH":U).  
        end.
   
    /** Returns the default cookie domain   */
    define public property DefaultCookieDomain as character no-undo     
        get():
            return web-context:get-cgi-value("ENV":U, "SERVLET_DEFAULT_COOKIE_DOMAIN":U) .  
        end.    

    /** The message's Transfer-Encoding. For more detail, see
        http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6 */  
    define public property TransferEncoding as character no-undo 
        get():
            return web-context:get-cgi-value("ENV":U, "HTTP_TRANSFER_ENCODING":U). 
        end.
        set(cProp as char):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.
    
    /** (mandatory) GET/PUT/POST etc, Maps to MethodEnum, although there are extension methods too */
    define public property Method as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "REQUEST_METHOD":U).
        end get.
        set(cProp as char):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.
    
    /** (mandatory) The URI to request eg. http://progress.com/ */
    define public property URI as URI no-undo
        get():
            define variable cScheme as character no-undo.
            define variable cHost   as character no-undo.
            define variable iPort   as integer no-undo.
            define variable cPath   as character no-undo.
            define variable cQueryString as character no-undo.
            
            /* use a private member so that set can throw readonly error */
            if not valid-object(mURI) then
            do:
                assign
                    cScheme = web-context:get-cgi-value("ENV":U, "REQUEST_SCHEME":U)
                    cHost = web-context:get-cgi-value("ENV":U, "SERVER_NAME":U)
                    /** PAS will always have a port number */
                    iPort = int(web-context:get-cgi-value("ENV":U, "SERVER_PORT":U))
                    cPath = web-context:get-cgi-value("ENV":U, "REQUEST_URI":U).         
            
                mURI = new URI(cScheme,cHost,iPort,cPath,createQueryMapFromContext(),?).
            end.
            return mURI.
        end get.
        set(newURI as URI):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.
    
    /** IP address of the interface on which the request was received */
    define public property LocalAddress as character no-undo
        get(): 
            return web-context:get-cgi-value("ENV":U, "LOCAL_ADDR":U).
        end get.
    
    /** Host name of the interface on which the request was received */
    define public property LocalHost as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "LOCAL_NAME":U).
        end get.
    
    /** Port number of the interface on which the request was received */
    define public property LocalPort as integer no-undo
        get():
            return integer(web-context:get-cgi-value("ENV":U, "LOCAL_PORT":U)).
        end get.
    
    /** IP address of the client or last proxy that sent the request */
    define public property RemoteAddress as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "REMOTE_ADDR":U).
        end get.
    
    /** Host name the client or the last proxy that sent the request */
    define public property RemoteHost as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "REMOTE_HOST":U).
        end get.
    
    /** Port of the client or last proxy that sent the request */
    define public property RemotePort as integer no-undo    
        get():
            return integer(web-context:get-cgi-value("ENV":U, "REMOTE_PORT":U)).
        end get.
    
    /** Login of the user making this request, or null if not authenticated */
    define public property RemoteUser as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "REMOTE_USER":U).
        end get.

    /** The part of this request's URL that specifies the OE transport */   
    define public property TransportPath as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "SERVLET_PATH":U).
        end get.
    
    /** The real path to the part of the URL specified by TransportPath */
    define public property ResolvedTransportPath as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "PATH_TRANSLATED":U).
        end get.
    
    /** The URL after the TransportPath. Does not include the query. */
    define public property PathInfo as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "PATH_INFO":U).
        end get.

    /** Portion of request URI that indicates the web application. */
    define public property WebAppPath as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "CONTEXT_PATH":U).
        end get.
    
    /** Returns a list of all context property names  */
    define public property ContextNames as character no-undo
        get():
            return web-context:get-cgi-list("ENV":U).
        end.    
       
    /** Return the server software  */
    define public property ServerSoftware as character no-undo 
        get():
            return web-context:get-cgi-value('ENV':u, "SERVER_SOFTWARE":U).
        end.
    
    /** Returns a comma-delimited list of path parameter names, for URI mappings */ 
    define public property PathParameterNames as character no-undo initial ?
        get():
            if this-object:PathParameterNames eq ? then
            do:
                define variable cNames as character no-undo.
                define variable cEntry as character no-undo.
                define variable iLoop as integer no-undo.
                define variable iMax as integer no-undo.
                define variable cDelimiter as character no-undo.
                
                assign cNames     = web-context:get-cgi-list("ENV":U)
                       iMax       = num-entries(cNames)
                       cDelimiter = '':u
                       .
                do iLoop = 1 to iMax:
                    assign cEntry = entry(iLoop, cNames).
                    if cEntry begins 'URI_':u then
                        assign cNames = cNames
                                      + cDelimiter 
                                      + replace(cEntry, 'URI_':u, '':u)
                               cDelimiter = ',':u.
                end.
                
                assign this-object:PathParameterNames = cNames.
            end.
            
            return this-object:PathParameterNames.
        end get.
        private set.

    /** Returns all the headers
        Note: As of current this is not cached 
              The assumption is that you will not call this multiple times per request
              since there is a getHeader(name) (which does not use this).      
        @param HttpHeader[] An array of headers
        @return integer The number of headers returned */
    method public integer GetHeaders(output poHeaders as HttpHeader extent):
        define variable cList        as character no-undo. 
        define variable i            as integer no-undo.
        define variable iNumHeaders  as integer no-undo.
        define variable cEntry       as character no-undo.
        define variable cHeaderNames as character no-undo.
        
        cList = web-context:get-cgi-list("ENV":U).
        do i = 1 to num-entries(cList):
            cEntry = entry(i,cList).
            if cEntry begins "HTTP_":U and
               HasHeader(substr(cEntry,6)) then
                assign cHeaderNames = cHeaderNames + ",":U + substr(cEntry,6).    
        end.
        
        assign cHeaderNames = left-trim(cHeaderNames,",":U)
               iNumHeaders = num-entries(cHeaderNames)
               extent(poHeaders) = iNumHeaders.
        
        do i = 1 to iNumHeaders:
            assign poHeaders[i] = GetHeader(entry(i,cHeaderNames)).
        end.
        
        return iNumHeaders.
    end method.
    
    /** creates a query map from the quesry string to pass to URI constructor*/
    method private IStringStringMap createQueryMapFromContext ():
        define variable cQueryString as character no-undo.
        define variable stringMap as IStringStringMap no-undo.
        define variable i as integer no-undo.
        define variable cProp as character no-undo.
        define variable cQuery as character no-undo.
        define variable cValue as character no-undo.
        stringMap = new StringStringMap().
        cQueryString = web-context:get-cgi-value("ENV":U, "QUERY_STRING":U).
        do i = 1 to num-entries(cQueryString,"&":U):           
            cQuery = entry(i,cQueryString,"&":U).  
            cProp = OpenEdge.Net.URI:Decode(entry(1,cQuery,"=":U)).
            if num-entries(cQuery,"=":U) > 1 then
            do:  
                cValue = OpenEdge.Net.URI:Decode(entry(2,cQuery,"=":U)).
            end.
            else do: 
                cValue = "":U.
            end.
            stringMap:Put(cProp,cValue).
        end. 
        return stringMap. 
    end.
    
    /** Removes headers is not implemented .
        @param character The name of the header to remove */    
    method public void RemoveHeader(pcName as character):
        undo, throw new AppError(GetMethodNotImplementedMessage(),?).
    end method.
    
    /** Set header is not implemented  */
    method public void SetHeader(poHeader as HttpHeader):
        undo, throw new AppError(GetMethodNotImplementedMessage(),?).
    end method.
    
    /** Remove all headers is not implemented .  */    
    method public void ClearHeaders():
        undo, throw new AppError(GetMethodNotImplementedMessage(),?).
    end method.
  
    /** Indicates whether a header exists for this message or not. 
                            
        @param character The name of a header to check
        @return logical True if this message contains the header */
    method public logical HasHeader(pcName as character):
        define variable headerValue as character no-undo.
        headerValue = GetHeaderValue(pcname).
        return headerValue > "":U.
    end method.
    
    /** Returns a named header
        @param  The name of the header to retrieve
        @return HttpHeader The header object. Null if not exists. */
    method public HttpHeader GetHeader(pcName as character):
        define variable headerValue as character no-undo.
        headerValue = GetHeaderValue(pcname).
        if(headerValue > "":U) then
            return HttpHeaderBuilder:Build(pcName):Value(headerValue):Header.
        else
            return ?.    
    end method.
    
    /* get the heder value as string - used by GetHeader and HasHeader */
    method private character GetHeaderValue(pcName as character):
        define variable cgiName     as character no-undo.
        define variable headerValue as character no-undo.
        
        cgiName = replace( pcName, "-":U, "_":U ).
        cgiName = "HTTP_":U + caps( cgiName ).
        headerValue = web-context:get-cgi-value( "ENV":U, cgiName ).
        return headerValue.
    end method.
    
    /** Set cookie is not implemented  */
    method public void SetCookie(poCookie as Cookie):
        undo, throw new AppError(GetMethodNotImplementedMessage(),?).
    end method.
    
    /** Remove cookie is not implemented 
        @param Cookie The cookie to remove. */
    method public void RemoveCookie(poCookie as Cookie):
        undo, throw new AppError(GetMethodNotImplementedMessage(),?).
    end method.    
    
    /** Removes all cookies is not implemented */ 
    method public void ClearCookies():
        undo, throw new AppError(GetMethodNotImplementedMessage(),?).
    end method.
        
    /** Returns all the cookies for this message
                                        
        @param Cookie[] An array of cookies 
        @return integer The number of cookies returned */
    method public integer GetCookies(output poCookies as Cookie extent):
        define variable cCookie    as character no-undo.
        define variable i          as integer no-undo.
        define variable cAttribute as character no-undo.
        define variable cName      as character no-undo.
        define variable cValue     as character no-undo.
        define variable iExt as integer no-undo.
        define variable defaultDomain as character no-undo.
        define variable defaultPath   as character no-undo.
        
        assign defaultDomain = this-object:DefaultCookieDomain.
        if defaultDomain = ?  then 
           assign defaultDomain = "":u.
        
        assign defaultPath =  this-object:DefaultCookiePath.
        if defaultPath = ? or defaultPath = "":u then
           assign defaultPath = this-object:WebAppPath.
            
        if extent(mCookies) = ? then
        do:
            /* alternative:  cCookie = GetHeader("Cookie"):Value() */ 
            cCookie = web-context:get-cgi-value( "ENV":U,"HTTP_COOKIE":U).
            if cCookie > "":u then 
            do:
                iExt = num-entries(cCookie,";":U).
                extent(mCookies) = iExt.
                do i = 1 to iExt:
                    assign cAttribute = entry(1, cCookie, ';':u)
                           cName = entry(1, cAttribute, '=':u)
                           cValue = entry(2, cAttribute, '=':u)
                           mCookies[i] = new Cookie(cName,defaultDomain,defaultPath,cValue). 
                end.
            end.
        end.
        poCookies = mCookies.
        return if extent(poCookies) = ? then 0 else extent(poCookies).
    end method.
    
    /** Indicates whether a cookie exists for this message
                                                
        @param Cookie The cookie to check 
        @return logical True if this message contains the cookie */
    method public logical HasCookie(poCookie as Cookie):
        define variable oCookies     as Cookie extent no-undo.
        define variable iNumCookies as integer no-undo.
        define variable i           as integer no-undo.
    
        Assert:NotNull(poCookie, 'Cookie').
        iNumCookies = GetCookies(output oCookies).
        do i = 1 to iNumCookies:
            if oCookies[i]:Equals(poCookie) then
                return true. 
        end.    
        return false.
    end method.
    
    /** get the named path value from the URI (see IWebRequest) */
    method public character GetPathParameter(pcName as character):
        define variable cgiName     as character no-undo.
        define variable paramValue       as character no-undo.
        cgiName = "URI_":U + caps( pcName ).
        paramValue = web-context:get-cgi-value( "ENV":U, cgiName ).
        return paramValue.
    end.    
    
    /** Get a value from the request context */
    method public longchar GetContextValue(pcName as character):
        define variable lcValue as longchar no-undo.
        
        /* Bug PSC00341711 means that we cannot trust the get-cgi-long-value. We have
           to assume it may fail and look for the 'short' value in that case. */
        assign lcValue = web-context:get-cgi-long-value( "ENV":U, pcName ) no-error.
        if error-status:error then
            assign lcValue = web-context:get-cgi-value( "ENV":U, pcName ).
        
        return lcValue.
    end method.     
    
    /** return read only message for property - must be called from setter **/
    method private char GetReadOnlyMessage( ):
        define variable cProp as character no-undo.
        define variable cClass as character no-undo.
        cProp = program-name(2).
        cClass = entry(2,cProp," ":U).
        cProp = substr(entry(1,cProp," ":U),9). 
        return substitute(BaseReadOnlyMessage,cClass,cProp).
    end method.        
   
    /** return not implemented message for property - must be called from setter and/or getter **/
    method private char GetPropNotImplementedMessage( ):
        define variable cProp as character no-undo.
        define variable cClass as character no-undo.
        cProp = program-name(2).
        cClass = entry(2,cProp," ":U).
        cProp = substr(entry(1,cProp," ":U),9). 
        return substitute(BaseNotImplementedMessage,cClass,cProp,"property").
    end method.       
     
   /** return not implemented message for method- must be called from the method **/
    method private char GetMethodNotImplementedMessage( ):
        define variable cMethod as character no-undo.
        define variable cClass as character no-undo.
        cMethod = program-name(2).
        cClass = entry(2,cMethod," ":U).
        cMethod = entry(1,cMethod," ":U). 
        return substitute(BaseNotImplementedMessage,cClass,cMethod,"method").
    end method.        
   
end class.