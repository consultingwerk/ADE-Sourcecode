/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : DefaultRequestFilter
    Purpose     : Writes data from a request into another data structure,
                  as passed into the Write() methods.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jan 26 09:57:31 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.HashAlgorithmEnum.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.String.
using OpenEdge.Core.System.InvalidCallError.
using OpenEdge.Net.URI.
using OpenEdge.Net.UriEncodingTypeEnum.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.ISupportProxy.
using Progress.Lang.AppError.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.TransferEncodingEnum.

class OpenEdge.Net.HTTP.Filter.Payload.DefaultRequestFilter 
        implements IHttpMessageWriter, ISupportInitialize:
    
    /* private and immutable constant value */
    define private property CRLF as character initial '~r~n':u no-undo get.
    
    define protected property Request as IHttpRequest no-undo get. private set.
    
    /** (mandatory) The message that's being written */  
    define public property Message as IHttpMessage no-undo
        get():
            return this-object:Request.
        end get.
    
    constructor public DefaultRequestFilter(input poMessage as IHttpRequest):
        Assert:NotNull(poMessage, 'Http Request').
                
        assign this-object:Request = poMessage.
    end method.
    
	method public void Write( input phData as handle ):
		/* no-op */
	end method.

	method public void Write( input-output pcData as character ):
	    define variable lcData as longchar no-undo.
	    
	    assign lcData = pcData.
	    this-object:Write(input-output lcData).
	end method.

    /* Initializer/Startup */
    method public void Initialize():
    end method.
    
    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy():
    end method.
    
    /**  Closes the output. See Open() */
    method public void Close():
        /* no-op */
    end method.

    /** Opens the writer for output. Open/Close allows us to write the same message multiple
        times without requiring a new writer each time. */
    method public void Open():
        /* no-op */ 
    end method.

    /** Write data to the output location 
    
        @param Object Data to write */
    method public void Write(input poData as Object):
        Assert:IsType(poData, get-class(ByteBucket)).
        
        WriteMessage(cast(poData, ByteBucket)).
    end method.
        
    /** Write data to the output location
        
        @param longchar Data to write */
    method public void Write(input-output pcData as longchar):
        define variable oBucket as ByteBucket no-undo.
        
        WriteMessage(oBucket).
        
        assign pcData = oBucket:GetString(1).
    end method.
    
    /** Write data to the output location 
        
        @param memptr Data to write */
    method public void Write(input pmData as memptr):
        define variable oBucket as ByteBucket no-undo.
        
        WriteMessage(oBucket).
        
        if oBucket:Size gt get-size(pmData) then
            return error new AppError(substitute('Input memptr too small (&1 bytes) to contain complete request (&2 bytes)',
                                            get-size(pmData), oBucket:Size), 0).
        
        assign pmData = oBucket:GetBytes():Value.
    end method.
    
    /**  Flushes data to the output location. What data is flushed depends on the implementation */
    method public void Flush():
        /* no-op */
    end method.
    
    /** Builds a complete HTTP request (ie headers, protocol etc)
        for the data in this object. */
    method protected void WriteMessage(input poMessageData as ByteBucket):
        define variable cAcceptTypes as character extent no-undo.
        define variable cAcceptValue as character no-undo.
        define variable cDelimiter as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oEntity as ByteBucket no-undo.
        define variable cContentType as character no-undo.
        
        WriteRequestLine(poMessageData).
        WriteHeaders(poMessageData).
        WriteCookies(poMessageData).
        
        /* ACCEPT-CONTENT-TYPE */
        /* Default to all. Add to the collection in case we reuse this request */
        assign cAcceptTypes = this-object:Request:AcceptContentType  
               iMax = extent(cAcceptTypes)
               cDelimiter = '':u
               cAcceptValue = '':u.
        
        if iMax eq ? then
            assign cAcceptValue = '*/*':u.
             
        do iLoop = 1 to iMax:
            assign cAcceptValue = cAcceptValue
                                + cDelimiter
                                + cAcceptTypes[iLoop]
                   cDelimiter = ',':u.
        end.
        WriteHeader(poMessageData, 'Accept':u, cAcceptValue).
        
        /* TRANSFER ENCODING */
        if not this-object:Message:TransferEncoding eq TransferEncodingEnum:None:Name then
            WriteHeader(poMessageData, 'Accept-Encoding':u, lc(this-object:Message:TransferEncoding)).
        
        /* PAYLOAD/BODY */
        if valid-object(this-object:Message:Entity) then
        do:
            /* Extract the Entity into the message body. Do this first because this extraction 
               will calculate the content type, charset etc. */
            assign oEntity = ExtractEntity()
                   /* Set the message's size, in bytes */
                   this-object:Message:ContentLength = oEntity:Size.
            
            WriteHeader(poMessageData,
                        'Content-Length':u,   string(this-object:Message:ContentLength)).
                        
            assign cContentType =  this-object:Message:ContentType.
            if this-object:Message:CharacterEncoding ne '':u then
                assign cContentType = substitute('&1; charset=&2':u,
                                                 cContentType,
                                                 this-object:Message:CharacterEncoding).
            WriteHeader(poMessageData, 'Content-Type':u, cContentType).
            
            /* update the content'd hash */
            assign this-object:Message:ContentMD5 = oEntity:GetHash(HashAlgorithmEnum:MD5).
        end.
        
        /* ALWAYS add a trailing CRLF to indicate end of headers. */
        poMessageData:PutString(CRLF).
        
        /* Add Body to the end of the payload */
        if this-object:Message:ContentLength gt 0 then
            poMessageData:PutBytes(oEntity).
    end method.
    
    /** Extracts the contents of the Entity property, and
        populates the MessageBody.
        
        This default implementation returns an empty message body. 
        
        @return Memptr A memptr object containing the extracted entity. */
    method protected ByteBucket ExtractEntity():
        return error new InvalidCallError(
                            'OpenEdge.Net.HTTP.Writer.DefaultRequestFilter:ExtractEntity':u,
                            'This is a virtual method, which should always be overridden, and never called directly.').
    end method.
    
/*** HELPER METHODS  ***/
    /** Writes the request line into the bucket 
    
        @param ByteBucket The target for the write operation */
    method protected void WriteRequestLine(input poMessageData as ByteBucket):
        define variable cRequestURI as character no-undo.

        if type-of(this-object:Request, ISupportProxy) then
            /* for proxies, we want http://example.com/some/data */
            assign cRequestURI = this-object:Request:URI:Encode().
        else
            /* for normal request, we want /some/data */
            assign cRequestURI = OpenEdge.Net.URI:Encode(this-object:Request:URI:RelativeURI, 
                                                         UriEncodingTypeEnum:Default).
        
        /* We always need some path in the request line */
        if cRequestURI eq '':u then
            assign cRequestURI = '/':u.
        
        poMessageData:PutString(substitute('&1 &2 &3':u,
                                this-object:Request:Method,
                                cRequestURI,
                                this-object:Request:Version      ) + CRLF).
    end method.
    
    /** Writes the HTTP headers into the bucket 
        
        @param ByteBucket The target for the write operation */
    method protected void WriteHeaders(input poMessageData as ByteBucket):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oHeader as HttpHeader extent no-undo.
        
        assign iMax = this-object:Message:GetHeaders(output oHeader).
        
        do iLoop = 1 to iMax:
            WriteHeader(poMessageData, oHeader[iLoop]:Name, oHeader[iLoop]:Value).  
        end.    /* header */
    end method.    
    
    /** Writes the HTTP cookies into the bucket 
    
        @param ByteBucket The target for the write operation */
    method protected void WriteCookies(input poMessageData as ByteBucket):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oCookies as Cookie extent no-undo.
        define variable cCookies as character no-undo.
        define variable cDelimiter as character no-undo.
        
        assign iMax = this-object:Message:GetCookies(output oCookies)
               cDelimiter = '':u.
        
        /* add on to any existing cookies */
        if this-object:Message:HasHeader('Cookie':u) then
            assign cCookies = this-object:Message:GetHeader('Cookie':u):Value.           
        if cCookies ne '':u then
            assign cDelimiter = '; ':u. 
        
        do iLoop = 1 to iMax: 
            assign cCookies = cCookies + cDelimiter
                            + substitute('&1=&2':u, 
                                    oCookies[iLoop]:Name,
                                    oCookies[iLoop]:Value)
                   cDelimiter = '; ':u.
        end.
        
        if cCookies ne '':u then
            WriteHeader(poMessageData, 'Cookie':u, cCookies).
    end method.    

    /* Helper method to write message headers into the http message */
    method protected void WriteHeader(input poBody as ByteBucket,
                                      input pcName as character,
                                      input pcValue as character):
        poBody:PutString(substitute('&1: &2':u, trim(pcName), pcValue) + CRLF).
    end method.
    
end class.

