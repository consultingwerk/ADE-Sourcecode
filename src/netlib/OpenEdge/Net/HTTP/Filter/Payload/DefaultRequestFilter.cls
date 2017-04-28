/************************************************
Copyright (c)  2015-2016 by Progress Software Corporation. All rights reserved.
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

using OpenEdge.Core.Assertion.AssertObject.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.HashAlgorithmEnum.
using OpenEdge.DataAdmin.Entity.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using OpenEdge.Net.ISupportEncoding.
using OpenEdge.Net.ISupportMultipartEntity.
using OpenEdge.Net.ISupportTransferEncoding.
using OpenEdge.Net.UriEncodingTypeEnum.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.DefaultRequestFilter inherits MessageWriter:
    
    /* private and immutable constant value */
    define protected property CRLF as character initial '~r~n':u no-undo get.
    
    constructor public DefaultRequestFilter():
        super(get-class(ByteBucket)).
    end constructor.    
    
    method override public int64 Write(input poData as Object):
        define variable iPrevSize as int64 no-undo.
        
        AssertObject:IsType(poData, get-class(IHttpRequest)).
        
        assign iPrevSize = cast(this-object:Entity, ByteBucket):Size.
        WriteMessage(cast(poData, IHttpRequest)).
        
        /* Only return what we write here */
        return (cast(this-object:Entity, ByteBucket):Size - iPrevSize).
    end method.    
    
    /** Builds a complete HTTP request (ie headers, protocol etc)
        for the data in this object. */
    method protected void WriteMessage(input poRequest as IHttpRequest):
        define variable cAcceptTypes as character extent no-undo.
        define variable cAcceptValue as character no-undo.
        define variable cDelimiter as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oEntity as ByteBucket no-undo.
        define variable cContentType as character no-undo.
        
        /* PAYLOAD/BODY */
        if valid-object(poRequest:Entity) then
            /* Extract the Entity into the message body. Do this first because this extraction 
               will calculate the content type, charset etc. */
            assign oEntity = ExtractEntity(poRequest).
        
        /* WRITE THE MESSAGE */
        WriteRequestLine(poRequest).
        WriteHeaders(poRequest).
        
        /* ALWAYS add a trailing CRLF to indicate end of headers. */
        cast(this-object:Entity, ByteBucket):PutString(CRLF).
        
        /* Add Body to the end of the payload */
        if poRequest:ContentLength gt 0 then
            cast(this-object:Entity, ByteBucket):PutBytes(oEntity).
    end method.
    
    /** Extracts the contents of the Entity property, and
        populates the MessageBody.
        
        This default implementation returns an empty message body. 
        
        @return Memptr A memptr object containing the extracted entity. */
    method protected ByteBucket ExtractEntity(input poRequest as IHttpRequest):
        define variable oBodyWriter as MessageWriter no-undo.
        define variable oMessageBody as ByteBucket no-undo.
        define variable iBytesWritten as int64 no-undo.
        
        assign oMessageBody = ByteBucket:Instance()
               oBodyWriter  = BodyWriterBuilder
                                :Build(poRequest)
                                :WriteTo(oMessageBody)
                                :Writer.
        if not valid-object(oBodyWriter) then
            return error new AppError('Unable to build request for transmission', 0).
        
        oBodyWriter:Open().
        /* writes the message's entity contents into a byte bucket */
        assign iBytesWritten = oBodyWriter:Write(poRequest:Entity).
        oBodyWriter:Close().
        
        /* Update the character encoding from the extraction */
        if type-of(oBodyWriter, ISupportEncoding) then
            assign poRequest:CharacterEncoding = cast(oBodyWriter, ISupportEncoding):Encoding.
            
        if type-of(oBodyWriter, ISupportMultipartEntity) then
            poRequest:GetHeader('Content-Type':u)
                     :SetParameterValue('boundary':u, quoter(cast(oBodyWriter, ISupportMultipartEntity):Boundary)).            

        if type-of(oBodyWriter, ISupportTransferEncoding) then
            assign poRequest:TransferEncoding = cast(oBodyWriter, ISupportTransferEncoding):TransferEncoding.
        
        assign poRequest:ContentLength = iBytesWritten
               /* Get the Entity from the writer; we don't know whether the writer
                  replaced the object or appended data to it, so make sure we get whatever
                  was written to. */
               oMessageBody            = cast(oBodyWriter:Entity, ByteBucket)
               poRequest:ContentMD5    = oMessageBody:GetHash(HashAlgorithmEnum:MD5)
               .
        return oMessageBody.
    end method.
    
/*** HELPER METHODS  ***/
    /** Writes the request line into the bucket 
    
        @param ByteBucket The target for the write operation */
    method protected void WriteRequestLine(input poRequest as IHttpRequest):
        define variable cRequestURI as character no-undo.
        
        /* encode unless already encoded (via check for % in the URL) */
        if type-of(poRequest, ISupportProxy) then
        do:
            /* for proxies, we want http://example.com/some/data */
            assign cRequestURI = poRequest:URI:ToString().
            if index(cRequestURI, '%':u) eq 0 then
                assign cRequestURI = poRequest:URI:Encode().
        end.
        else
        do:
            /* for normal request, we want /some/data */
            assign cRequestURI = poRequest:URI:RelativeURI.
            if index(cRequestURI, '%':u) eq 0 then
                assign cRequestURI = OpenEdge.Net.URI:Encode(cRequestURI, UriEncodingTypeEnum:Default).
        end.
        
        /* We always need some path in the request line */
        if cRequestURI eq '':u then
            assign cRequestURI = '/':u.
        
        cast(this-object:Entity, ByteBucket):PutString(substitute('&1 &2 &3':u,
                                caps(poRequest:Method),
                                cRequestURI,
                                poRequest:Version ) + CRLF).
    end method.
    
    /** Writes the HTTP headers into the bucket 
        
        @param ByteBucket The target for the write operation */
    method protected void WriteHeaders(input poRequest as IHttpRequest):
        define variable iLoop as integer no-undo.
        define variable oHeader as HttpHeader extent no-undo.
        
        do iLoop = poRequest:GetHeaders(output oHeader) to 1 by -1:
            cast(Entity, ByteBucket):PutString(substitute('&1&2':u,
                                    oHeader[iLoop]:ToString(),
                                    CRLF)).
        end.    /* header */
        
        /* ACCEPT */
        if not poRequest:HasHeader('Accept':u) then
            /* Default to all. */
            cast(Entity, ByteBucket):PutString('Accept: */*':u + CRLF).
        
        /* TRANSFER ENCODING */
        if not poRequest:TransferEncoding eq string(TransferEncodingEnum:None) then
            cast(Entity, ByteBucket):PutString(substitute('Accept-Encoding: &1&2':u,
                                            lc(poRequest:TransferEncoding),
                                            CRLF)).
    end method.
    
end class.
