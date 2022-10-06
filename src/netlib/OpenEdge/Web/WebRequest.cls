/************************************************
Copyright (c) 2015-2016, 2018, 2021-2022 by Progress Software Corporation. All rights reserved.
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

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.StringKeyedMap.
using OpenEdge.Core.HashAlgorithmEnum.
using OpenEdge.Core.String.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.URI.
using OpenEdge.Web.IWebRequest.
using Progress.Collections.List.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Web.WebRequest implements IWebRequest:
    define private variable mUri as URI no-undo.
    define private variable mCookies as IStringKeyedMap no-undo.
   
    define private variable BaseReadOnlyMessage as character no-undo
        init "&1.&2 property is read-only".
    
    define private variable BaseNotImplementedMessage as character no-undo
        init "&1.&2 &3 is not implemented".
       
    /** The HTTP version supported. Typically HTTP/1.1  */
    {&_proparse_ prolint-nowarn(varusage)}
    define public property Version as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "SERVER_PROTOCOL":U).
        end get.
        set(cProp as char):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.
    
    /** The message's content type (eg text/html). For more detail, see
        http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.7 */
    {&_proparse_ prolint-nowarn(varusage)}
    define public property ContentType as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "CONTENT_TYPE":U).
        end get.
        set(cProp as char):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.
    
    /** The message's content type encoding (eg charset='utf-8'). For more detail, see
        http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.7 */
    {&_proparse_ prolint-nowarn(varusage)}
    define public property CharacterEncoding as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "CHARACTER_ENCODING":U).
        end get.
        set(cProp as char):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.
  
    /**  An MD5 hash of the message's content. */
    {&_proparse_ prolint-nowarn(varusage)}
    define public property ContentMD5 as raw no-undo
        get():
            if length(this-object:ContentMD5) eq 0 then
                assign this-object:ContentMD5 = GetRawEntity():GetHash(HashAlgorithmEnum:MD5).
            
            return this-object:ContentMD5.
        end.
        set(rVal as raw):
            undo, throw new AppError(GetPropNotImplementedMessage(),?).
        end.
    
    // holder for the entity, so we only need to extract this once
    define private variable mEntity as Progress.Lang.Object no-undo.
    // holder for the RAW/bytes-only entity, so we only need ot create it once
    var private class Memptr mRawEntity.
    
    /** Object containing the message body/entity. The object can be of any type,
        which may depend on the content type.
        
        One of a Progress.Json.ObjectModel.JsonObject, OpenEdge.Core.WidgetHandle or OpenEdge.Core.Memptr is returned. These
        objects are created without the use of the EntityWriterBuilder, and so do not depend on any registered
        writers.
        
        A JsonObject is returned if the content-type is "text/json" or "application/json".
        A WidgetHandle is returned if the content-type is "text/xml" or "application/xml"
        A Memptr is returned for all other content-types, and also if no body is present.
        
        A cached instance is returned, since the message body bytes cannot change between calls. */
    {&_proparse_ prolint-nowarn(varusage)}
    define public property Entity as Object no-undo
        get():
            var memptr body. // Just a primitive datatype, not a Memptr object.
            
            if not valid-object(mEntity) then
            do:
                if web-context:is-xml then
                    // Do NOT clean up the X-DOC handle when this object goes out of scope. The AVM will take care of it at
                    // the end of this request.
                    //
                    // Only one X-DOC handle is created ever by thw WEB-CONTEXT handle; we should not manually (ie 'auto')
                    // delete it.
                    assign mEntity = new WidgetHandle(web-context:x-document, no).
                else
                if web-context:is-json then
                    assign mEntity = new ObjectModelParser():Parse(web-context).
                else
                do on error undo, throw:
                    assign body = web-context:form-long-input.
                    if get-size(body) eq ? then
                        assign mEntity = Memptr:Empty.
                    else
                        assign mEntity = new Memptr(body).
                    finally:
                        set-size(body) = 0.
                    end finally.
                end.
            end.
            return mEntity.
        end.
        set(oProp as Object):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.
        
    /**  The length (in bytes/characters) of the payload/entity. */
    {&_proparse_ prolint-nowarn(varusage)}
    define public property ContentLength as int64 no-undo
        get():
            return int64(web-context:get-cgi-value("ENV":U, "CONTENT_LENGTH":U)).
        end get.
        set(iProp as int64):
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
    {&_proparse_ prolint-nowarn(varusage)}
    define public property TransferEncoding as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "HTTP_TRANSFER_ENCODING":U).
        end.
        set(cProp as char):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.
    
    /** (mandatory) GET/PUT/POST etc, Maps to MethodEnum, although there are extension methods too */
    {&_proparse_ prolint-nowarn(varusage)}
    define public property Method as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "REQUEST_METHOD":U).
        end get.
        set(cProp as char):
            undo, throw new AppError(GetReadOnlyMessage(),?).
        end set.
    
    /** (mandatory) The URI to request eg. http://progress.com/ */
    {&_proparse_ prolint-nowarn(varusage)}
    define public property URI as URI no-undo
        get():
            /* use a private member so that set can throw readonly error */
            if not valid-object(mURI) then
                assign mURI = new URI(web-context:get-cgi-value("ENV":U, "REQUEST_SCHEME":U),
                                      web-context:get-cgi-value("ENV":U, "SERVER_NAME":U),
                                      /** PAS will always have a port number */
                                      integer(web-context:get-cgi-value("ENV":U, "SERVER_PORT":U)),
                                      web-context:get-cgi-value("ENV":U, "REQUEST_URI":U),
                                      createQueryParamsFromContext(),
                                      ?)
                       .
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
    
    /* The real (file) path to the web application. */
    define public property ResolvedWebAppPath as character no-undo
        get():
            return web-context:get-cgi-value("ENV":U, "BASE_PATH":U).
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
                
                assign cNames             = web-context:get-cgi-list("ENV":U)
                       iMax               = num-entries(cNames)
                       cDelimiter         = '':u
                       PathParameterNames = '':u
                       .
                do iLoop = 1 to iMax:
                    assign cEntry = entry(iLoop, cNames).
                    if cEntry begins 'URI_':u then
                        assign PathParameterNames = PathParameterNames
                                                    + cDelimiter
                                                    + replace(cEntry, 'URI_':u, '':u)
                               cDelimiter = ',':u.
                end.
            end.
            
            return this-object:PathParameterNames.
        end get.
        private set.

    /* Returns the URI template used to find the handler for this request. May be empty */
    define public property UriTemplate as character no-undo initial ?
        get():
            if this-object:UriTemplate eq ? then
                assign this-object:UriTemplate = web-context:get-cgi-value('ENV':u, 'URI_TEMPLATE':u).
            
            return this-object:UriTemplate.
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
            assign cEntry = entry(i,cList).
            if cEntry begins "HTTP_":U then
                assign cHeaderNames = cHeaderNames + ",":U
                                    + replace(substring(cEntry, 6), '_':u, '-':u).
        end.
        
        assign cHeaderNames      = left-trim(cHeaderNames, ",":U)
               iNumHeaders       = num-entries(cHeaderNames)
               extent(poHeaders) = iNumHeaders
               .
        do i = 1 to iNumHeaders:
            assign poHeaders[i] = GetHeader(entry(i,cHeaderNames)).
        end.
        
        return iNumHeaders.
    end method.
    
    /** creates a query map from the quesry string to pass to URI constructor*/
    method private IStringKeyedMap createQueryParamsFromContext ():
        var IStringKeyedMap keyedMap.
        var character cQueryString, cProp, cPropName, cQuery, cValue.
        var integer iLoop, iPos.
        
        assign keyedMap = new StringKeyedMap()
               cQueryString = web-context:get-cgi-value("ENV":U, "QUERY_STRING":U).
         
        do iLoop = 1 to num-entries(cQueryString,"&":U):
            cQuery = entry(iLoop, cQueryString,"&":U).
            assign iPos  = index(cQuery, '=':u).
            if iPos eq 0 then
                assign iPos = index(cQuery, ';':u).
                
            if iPos eq 0 then
                assign cProp  = cQuery
                       cValue = '':u.
            else
            do:
                assign cProp = substring(cQuery, 1, iPos - 1)
                       cValue = substring(cQuery, iPos + 1)
                       no-error.
                if cValue eq ? then
                    assign cValue = '':u.
            end.

            // Create a new List<String> for values for this key name.
            assign cPropName = OpenEdge.Net.URI:Decode(cProp).
            if not keyedMap:ContainsKey(cPropName) then
                keyedMap:Put(cPropName, new List<String>()).

            cast(keyedMap:Get(cPropName), List<String>):Add(new String(OpenEdge.Net.URI:Decode(cValue))).
        end.

        return keyedMap.
    end method.
    
    /** Removes headers is not implemented .
        @param character The name of the header to remove */
    {&_proparse_ prolint-nowarn(varusage)}
    method public void RemoveHeader(pcName as character):
        undo, throw new AppError(GetMethodNotImplementedMessage(),?).
    end method.
    
    /** Set header is not implemented  */
    method public void SetHeader(poHeader as HttpHeader):
        undo, throw new AppError(GetMethodNotImplementedMessage(),?).
    end method.
    
    /** Set header is not implemented  */
    {&_proparse_ prolint-nowarn(varusage)}
    method public void SetHeaders(poHeader as HttpHeader extent):
        undo, throw new AppError(GetMethodNotImplementedMessage(),?).
    end method.
    
    /** Adds header info to this message's collection of headers.
        
        @param character The header name
        @param character The header value
        @return HttpHeader The header actual header */
    {&_proparse_ prolint-nowarn(varusage)}
    method public HttpHeader SetHeader(input pName as character,
                                       input pValue as character):
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
        return lookup(substitute('HTTP_&1':u, caps(replace(pcName, '-':u, '_':u))), web-context:get-cgi-list("ENV":U)) gt 0.
    end method.
    
    /** Returns a named header
        
        @param  character  The name of the header to retrieve
        @return HttpHeader The header object. The NullHeader object is returned if the header is not set on the request */
    method public HttpHeader GetHeader(pcName as character):
        if HasHeader(pcName) then
            return HttpHeaderBuilder:Build(pcName)
                        :Value(GetHeaderValue(pcName))
                        :Header.
        else
            return OpenEdge.Net.HTTP.HttpHeader:NullHeader.
    end method.
    
    /** Gets a character header value
    
        @param character The name of the header
        @return character the value of the header. */
    method private character GetHeaderValue(pcName as character):
        define variable cgiName     as character no-undo.
        define variable headerValue as character no-undo.
        
        cgiName = replace( pcName, "-":U, "_":U ).
        cgiName = "HTTP_":U + caps(cgiName ).
        headerValue = web-context:get-cgi-value( "ENV":U, cgiName ).
        return headerValue.
    end method.
    
    /** Set cookie is not implemented  */
    {&_proparse_ prolint-nowarn(varusage)}
    method public void SetCookie(poCookie as Cookie):
        undo, throw new AppError(GetMethodNotImplementedMessage(),?).
    end method.
    
    /** Set cookie is not implemented  */
    {&_proparse_ prolint-nowarn(varusage)}
    method public void SetCookies(poCookie as Cookie extent):
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
        if not valid-object(mCookies) then
            LoadCookies().
        
        assign poCookies = cast(mCookies:Values:ToArray(), Cookie).
        
        return mCookies:Size.
    end method.
    
    /** Indicates whether a cookie exists for this message
                                                
        @param Cookie The cookie to check
        @return logical True if this message contains the cookie */
    method public logical HasCookie(poCookie as Cookie):
        Assert:NotNull(poCookie, 'Cookie').
        return HasCookie(poCookie:Name).
    end method.
    
     /** Indicates whether a cookie exists for this message
        
        @param character The cookie's name to check
        @return logical TRUE if this message contains the cookie */
    method public logical HasCookie(input pcName as character):
        Assert:NotNullOrEmpty(pcName, 'Cookie name').
        if not valid-object(mCookies) then
            LoadCookies().
        
        return mCookies:ContainsKey(pcName).
    end method.
    
    /** Returns a cookie by name from this message. Typically
        returns the first cookie it finds by name, oif more than
        one exist
        
        @param character The cookie's name to check
        @return Cookie The (first) cookie found by name */
    method public Cookie GetCookie(input pcName as character):
        if not valid-object(mCookies) then
            LoadCookies().
        
        return cast(mCookies:Get(pcName), Cookie).
    end method.
    
    /** Removes cookies from this message for a given name
    
        @param character The name of the cookie(s) to remove. */
    {&_proparse_ prolint-nowarn(varusage)}
    method public void RemoveCookie(input pcName as character):
        undo, throw new AppError(GetMethodNotImplementedMessage(),?).
    end method.
    
    /** get the named path value from the URI (see IWebRequest) */
    method public character GetPathParameter(pcName as character):
        define variable cgiName     as character no-undo.
        define variable paramValue       as character no-undo.
        cgiName = replace( pcName, "-":U, "_":U ).
        cgiName = "URI_":U + caps( cgiName ).
        paramValue = web-context:get-cgi-value( "ENV":U, cgiName ).
        return paramValue.
    end method.
    
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
    
    /* Private method */
    method private void LoadCookies():
        define variable cCookie as character no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable defaultDomain as character no-undo.
        define variable defaultPath as character no-undo.
        define variable cAttribute as character no-undo.
        define variable cName as character no-undo.
        define variable cValue as character no-undo.
        define variable chrPos as integer no-undo.
        
        assign defaultDomain = this-object:DefaultCookieDomain.
        if defaultDomain eq ?  then
           assign defaultDomain = "":u.
        
        assign defaultPath = this-object:DefaultCookiePath.
        if defaultPath eq ? or defaultPath eq "":u then
           assign defaultPath = this-object:WebAppPath.
        
        assign mCookies = new StringKeyedMap()
               cCookie  = web-context:get-cgi-value( "ENV":U,"HTTP_COOKIE":U)
               iMax     = num-entries(cCookie,";":u)
               .
        do iLoop = 1 to iMax:
            assign cAttribute = entry(iLoop, cCookie, ';':u)
                   // Don't use NUM-ENTRIES('=') for the name/value split since it's legal to have = in the value of a cookie
                   chrPos     = index(cAttribute, '=':u)
                   cName      = trim(substring(cAttribute, 1, chrPos - 1))
                   cValue     = substring(cAttribute, chrPos + 1)
                   .
            mCookies:Put(cName,  new Cookie(cName,defaultDomain,defaultPath,cValue)).
        end.
    end method.

    /** Returns a 'strongly-typed' object, converted based on the ContentType using the writers in the
        EntityWriterRegistry.
        
        A new instance is returned on each call, since the EntityWriterRegistry may have been modified from call to call.
        
        @return Object An object of an appropriate type for the request's ContentType. */
    @since(rel='12.5.0').
    method public Object GetTypedEntity():
        var memptr body. // Just a primitive datatype, not a Memptr object.
        var MessageWriter mw = EntityWriterBuilder:Build(this-object):Writer.
        
        // If we can't find a writer, return the best-guess (ie the Entity property)
        if not valid-object(mw) then
            return this-object:Entity.
        
        mw:Open().
        
        if web-context:is-xml then
            mw:Write(web-context:x-document).
        else
        do on error undo, throw:
            assign body = web-context:form-long-input.
            if get-size(body) gt 0 then
                mw:Write(body).
            finally:
                set-size(body) = 0.
            end finally.
        end.
        // if there's no body, an appropriate object will be returned from the message writer
        // so no need for an "else" here
        
        mw:Close().
        
        return mw:Entity.
    end method.
    
    /** Returns the bytes for the entity - unconverted - regardless of the ContentType.
        
        A cached instance is of Memptr returned, since the bytes cannot change between calls.
        
        @return Memptr The entity/body as bytes, uncoverted even for XML or JSON. */
    @since(rel='12.5.0').
    method public class Memptr GetRawEntity():
        var memptr body. // Just a primitive datatype, not a Memptr object.
        if not valid-object(mRawEntity) then
        do:
            assign body = web-context:form-long-input.
            if get-size(body) eq ? then
                assign mRawEntity = Memptr:Empty.
            else
                assign mRawEntity = new Memptr(body).
        end.
        
        return mRawEntity.
        finally:
            set-size(body) = 0.
        end finally.
    end method.
    
end class.
