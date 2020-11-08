/************************************************
Copyright (c)  2015-2016, 2020 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
   Purpose     : Writes data to a (web) stream from either a repsonse object
                 or from "Write" calls made by a caller.
   Syntax      : 
   Description : 
   Author(s)   : mbanks
   Created     : Mon Feb 02 11:54:49 EST 2015
   Notes       : 
   @since      : 11.6
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.StringConstant.
using OpenEdge.Net.HTTP.Cookie from propath.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader from propath.
using OpenEdge.Net.HTTP.IHttpMessage from propath.
using OpenEdge.Net.HTTP.IHttpResponse from propath.
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using Progress.IO.OutputStream from propath.

class OpenEdge.Web.WebResponseWriter inherits OutputStream:
    
    define private stream web_stream.
    
    // TRUE if the response line and set of headers have been written
    define private variable preamble_written as logical no-undo.
    
    /* The stream to which we are writing */
    define public property WebStream as handle no-undo 
        get ():
            return stream web_stream:handle.
        end.
    
    /* The response being written */
    define protected property Response as IHttpResponse no-undo
        get.
        set(input poResponse as IHttpResponse):
            Assert:NotNull(poResponse, 'Http Response').
            
            assign this-object:Response = poResponse.
        end set.
    
    define public property Message as IHttpMessage no-undo 
        get().
           return Response.
        end.
    
    /*  Constructor
        
        @param IHttpResponse The response being written */
    constructor public WebResponseWriter( poResponse as IHttpResponse ):
        this-object().
        assign this-object:Response = poResponse.
    end.
    
    /*  Default Constructor */
    constructor public WebResponseWriter():
        this-object:Open().
        
        // we can only ever write the preamble once per output stream
        assign this-object:preamble_written = false.
    end constructor.
    
    /* Opens the web stream */
    method public void Open():
        /* allow for reopens */
        output stream-handle WebStream close.
        output stream-handle WebStream TO "WEB":u.
    end method.
    
    /* Closes the web stream */
    method public override void Close(  ):
        this-object:Flush().
        
        output stream-handle WebStream close.
    end method.
    
    /* Flushes the contents to the web stream */
    method public override void Flush():
        WriteHttpPreamble().
        WriteBody().
    end method.
    
    /*  Writes a complete memptr to the web stream
        
        @param memptr A chunk of data as a memptr
        @return int64 The number of bytes written */
    method public override int64 Write(input pData as memptr):
        define variable bytesWritten as int64 no-undo.
        
        WriteHttpPreamble().
        
        assign bytesWritten = get-size(pData).
        
        export stream-handle WebStream pData.
        
        return bytesWritten.
    end method.
    
    /*  Writes some bytes from a memptr to the web stream 
     
        @param memptr The entire memptr
        @param int64 The offset (start byte)
        @param int64 The number of bytes to write from the offset
        @return int64 The number of bytes written */
    method public override int64 Write( pmData as memptr, offset as int64 , len as int64  ):
        define variable tmpmemptr as memptr.
        define variable lenmemptr as integer.
        
        assign lenmemptr = get-size(pmData).
        
        if lenmemptr eq 0 or
           offset    lt 1 or
           len       le 0 or
           (offset ge lenmemptr) or
           /* 1-based counting in ABL */
           (offset + len - 1) gt lenmemptr
        then
            return 0.
        
        /* if it's the whole memptr, just dump it */
        if len eq lenmemptr and offset eq 1 then
            return this-object:Write(pmData).
        else
        do on error undo, throw:
            tmpmemptr = get-bytes( pmData, offset, len ).
            
            return this-object:Write(tmpmemptr).
            finally:
                set-size(tmpmemptr) = 0.
            end finally.
        end.
        
        return len.
    end method.
    
    /*  Writes character data to the web stream 
     
        @param longchar The data to write to the web stream 
        @return int64 The number of bytes written */
    method public override int64 Write( lcData as longchar ):
        WriteHttpPreamble().
        
        export stream-handle WebStream lcData.
        
        return length(lcData, "RAW":u). 
    end method.
    
    /*  Writes character data to the web stream 
         
        @param character The data to write to the web stream 
        @return int64 The number of bytes written */
    method public override int64 Write(pcData as character).
        WriteHttpPreamble().
        
        put stream-handle WebStream unformatted pcData.
        
        return length(pcData, 'raw':u).
    end method.
    
    /* Writes out the HTTP status line & headers.
       
       If the response's ContentLength has been set and there's no Entity/body, then
       we may be dealing with a response to a HEAD request, in which case respect the
       previously-set value, and send back the value.
        
       Otherwise used Transfer-Encoding: chunked    */
    method protected void WriteHttpPreamble():
        if    this-object:preamble_written
           or not valid-object(Response)
        then
            return.
        
        assign preamble_written = true.
        
        WriteStatusLine().
        
        if  not valid-object(Response:Entity) 
        and Response:HasHeader('Content-Length':u)
        then
            // response to a HEAD request, we assume
            .
        else
        do:
            // Per https://tools.ietf.org/html/rfc7230#section-3.3.2 , there MUST NOT be a Content-Length header
            // when there is transfer encoding
            this-object:Response:RemoveHeader('Content-Length':u).
            WriteHeader('Transfer-Encoding':u, lc(string(TransferEncodingEnum:Chunked))).
        end.
        
        // OTHER HEADERS
        WriteHeaders().
        WriteCookies().
        
        /* Blank line separates headers from response body. */
        put stream-handle WebStream unformatted
                StringConstant:CRLF.
    end method.
    
    /* Writes the status line */
    method protected void WriteStatusLine():
        if not valid-object(Response) then
            return.
        
        put stream-handle WebStream unformatted
            substitute('&1 &2 &3':u, Response:Version, Response:StatusCode, Response:StatusReason) 
            StringConstant:CRLF 
        .
    end method.
    
    /* Writes all headers */
    method protected void WriteHeaders():
        define variable iLoop    as integer    no-undo.
        define variable iMax     as integer    no-undo.
        define variable oHeaders as HttpHeader extent no-undo.
        
        if not valid-object(Response) then
            return.
        
        iMax = this-object:Message:GetHeaders(output oHeaders).
        do iLoop = 1 to iMax:
            put stream-handle WebStream unformatted
                    oHeaders[iLoop]:ToString()
                    StringConstant:CRLF.
        end.    /* header */
    end method.
    
    /* Writes all cookies into the web stream */
    method protected void WriteCookies():
        define variable iLoop    as integer no-undo.
        define variable iMax     as integer no-undo.
        define variable oCookies as Cookie  extent no-undo.
        
        if not valid-object(Response) then
            return.
        
        iMax = this-object:Message:GetCookies(output oCookies).
        do iLoop = 1 to iMax: 
            WriteHeader( 'Set-Cookie':u, oCookies[iLoop]:ToString() ).
        end.
    end method.
    
    /* Helper method to write message headers into the http message
       @param character The header name
       @param character The header value */
    method private void WriteHeader(pcName as character, pcValue as character):
        put stream-handle WebStream unformatted
                    substitute('&1: &2':u, trim(pcName), pcValue)
                    StringConstant:CRLF.
    end method.
    
    /* Converts the response Entity into a set of bytes for returning to the client
       
       @return ByteBucket A container for the message body */
    method protected ByteBucket ExtractEntity():
        define variable body as ByteBucket no-undo.
        define variable ctWriter as MessageWriter no-undo.
        
        if    not valid-object(this-object:Response)
           or not valid-object(this-object:Response:Entity)
        then
            return body.
        
        if type-of(Response:Entity, ByteBucket) then
            return cast(Response:Entity, ByteBucket).
        
        assign body     = ByteBucket:Instance()
               ctWriter = BodyWriterBuilder:Build(this-object:Response)
                                :WriteTo(body)
                                :Writer
               .
        if not valid-object(ctWriter) then
            return body.
        
        ctWriter:Open().
        ctWriter:Write(this-object:Response:Entity).
        ctWriter:Close().
        
        return body.
    end method.
    
    /* Dumps a complete response to the output stream. */ 
    method protected void WriteBody():
        define variable mEntity as memptr no-undo.
        
        if not valid-object(Response)
        or not valid-object(Response:Entity)
        then
            return.
        
        /* Convert from a strongly-typed body object to bytes */
        if type-of(this-object:Response:Entity, ByteBucket) then
            assign mEntity = cast(Response:Entity, ByteBucket):GetBytes():Value.
        else
        if type-of(this-object:Response:Entity, IMemptrHolder) then
            assign mEntity = cast(this-object:Response:Entity, IMemptrHolder):Value.
        else
            assign mEntity = ExtractEntity():GetBytes():Value.
        
        // write the bytes out
        export stream-handle WebStream mEntity.
        
        finally:
            if get-size(mEntity) gt 0 then
                set-size(mEntity) = 0.
        end finally.
    end method.
end class.
