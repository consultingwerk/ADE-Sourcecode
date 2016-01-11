/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : mbanks
   Created     : Mon Feb 02 11:54:49 EST 2015
   Notes       : 
   @since      : 11.6    
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.Cookie from propath.
using OpenEdge.Net.HTTP.HttpHeader from propath.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IHttpMessage from propath.
using OpenEdge.Net.HTTP.IHttpResponse from propath.
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using Progress.IO.OutputStream from propath.

class OpenEdge.Web.WebResponseWriter inherits OutputStream:
    
    define private stream web_stream.
    define private variable written as logical no-undo.
    
    define private property CRLF as character initial '~r~n':u no-undo get.
    
    /* The stream to which we are writing */
    define public property WebStream as handle no-undo 
        get ():
            return stream web_stream:handle.
        end.
    
    /* */
    define protected property Response as IHttpResponse no-undo 
        get.
        set(input poResponse as IHttpResponse):
            Assert:NotNull(poResponse, 'Http Response').
            
            assign this-object:Response = poResponse.
            this-object:Open().
        end set.
    
    define public property Message as IHttpMessage no-undo 
        get().
           return Response.
        end.   
        
    /*  Constructor
    
        @param IHttpResponse The response being written */
    constructor public WebResponseWriter( poResponse as IHttpResponse ):
        this-object().
        Response = poResponse.
    end.

    /*  Default Constructor */
    constructor public WebResponseWriter():
    end constructor.
    
    /* Opens the web stream */
    method public void Open(  ):
        /* allow for reopens */
        output stream web_stream close.
        output stream web_stream TO "WEB":u.
    end method.
    
    /* Closes the web stream */
    method public override void Close(  ):
        this-object:Flush().
        output stream web_stream close.
    end method.
    
    /* Flushes the contents to the web stream */
    method public override void Flush(  ):
        if this-object:written = false then
            WriteHttpPreamble().
    end method.
    
    /*  Writes some bytes from a memptr to the web stream 
     
        @param memptr The entire memptr
        @param int64 The offset (start byte)
        @param int64 The number of bytes to write from the offset
        @return int64 The number of bytes written */
    method public override int64 Write( pmData as memptr, offset as int64 , len as int64  ):
        define variable tmpmemptr as memptr.
        define variable lenmemptr as integer.
        
        this-object:Flush().

        lenmemptr = get-size(pmData).

        if lenmemptr eq 0 or
           offset    lt 1 or
           len       le 0 or
           (offset ge lenmemptr) or
           /* 1-based counting in ABL */            
           (offset + len - 1) gt lenmemptr then
            return 0.

        /* if it's the whole memptr, just dump it */
        if len eq lenmemptr and offset eq 1 then
            export stream-handle WebStream pmData.
        else
        do:
            tmpmemptr = get-bytes( pmData, offset, len ).
            export stream-handle WebStream tmpmemptr.
        end.
        
        return len.
        finally:
            set-size( tmpmemptr ) = 0.
        end finally.
    end method.
    
    /*  Writes character data to the web stream 
     
        @param longchar The data to write to the web stream 
        @return int64 The number of bytes written */
    method public override int64 Write( lcData as longchar ):
        this-object:Flush().
        
        export stream-handle WebStream lcData.      
        return length( lcData, "RAW" ).
    end method.

    /*  Writes character data to the web stream 
     
        @param character The data to write to the web stream 
        @return int64 The number of bytes written */
    method public override int64 Write(pcData as character).
        this-object:Flush().
        put stream-handle WebStream unformatted pcData.
        return length(pcData).
    end method.
    
    /* Writes out the HTTP status line & headers */
    method protected void WriteHttpPreamble():
        this-object:written = true.
        
        /* TRANSFER ENCODING */
        if not Response:TransferEncoding eq string(TransferEncodingEnum:None) then
            Response:SetHeader(HttpHeaderBuilder:Build('Transfer-Encoding':u)
                                    :Value(lc(Response:TransferEncoding))
                                    :Header).
                
        WriteStatusLine().
        WriteHeaders().
        WriteCookies().
        /* Blank line separates headers from response body. */
        this-object:WriteToStream( CRLF ).
    end method.
    
    /* Writes the status line */
    method protected void WriteStatusLine():
        this-object:WriteToStream(
            Response:Version
            + " ":u
            + string( Response:StatusCode ) 
            + " ":u
            + Response:StatusReason 
            + CRLF 
        ).
    end method.

    /* Writes all headers */
    method protected void WriteHeaders():
        define variable iLoop    as integer    no-undo.
        define variable iMax     as integer    no-undo.
        define variable oHeaders as HttpHeader extent no-undo.

        iMax = this-object:Message:GetHeaders(output oHeaders).
        do iLoop = 1 to iMax:
            this-object:WriteToStream(oHeaders[iLoop]:ToString() + CRLF).
        end.    /* header */
    end method.    
    
    /* Writes all cookies into the web stream */
    method protected void WriteCookies():
        define variable iLoop    as integer no-undo.
        define variable iMax     as integer no-undo.
        define variable oCookies as Cookie  extent no-undo.
        
        iMax = this-object:Message:GetCookies(output oCookies).
        do iLoop = 1 to iMax: 
            WriteHeader( 'Set-Cookie':u, oCookies[iLoop]:ToString() ).
        end.
    end method.
        
    /* Writes some character data to the stream
       @param character Data to write */
    method private void WriteToStream( input pcData as character ):
        put stream-handle WebStream unformatted pcData.
    end method.

    /* Helper method to write message headers into the http message
       @param character The header name
       @param character The header value */
    method private void WriteHeader(pcName as character, pcValue as character):
        this-object:WriteToStream( substitute('&1: &2':u, trim(pcName), pcValue) + CRLF ).
    end method.

end class.
