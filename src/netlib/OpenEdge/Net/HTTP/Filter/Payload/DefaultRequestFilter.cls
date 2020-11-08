/************************************************
Copyright (c) 2015-2017 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.IAdaptable.
using OpenEdge.Core.StringConstant.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.ISupportProxy.
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using OpenEdge.Net.ISupportEncoding.
using OpenEdge.Net.ISupportMultipartEntity.
using OpenEdge.Net.ISupportTransferEncoding.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.DefaultRequestFilter inherits MessageWriter:
    /* Default constructor */
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
        else
        do:
            // No need for the Content-Type or -Length to be sent, if they've been previously set
            poRequest:RemoveHeader('Content-Type').
            poRequest:RemoveHeader('Content-Length').
        end.
        
        /* WRITE THE MESSAGE */
        WriteRequestLine(poRequest).
        WriteHeaders(poRequest).
        
        /* ALWAYS add a trailing CRLF to indicate end of headers. */
        cast(this-object:Entity, ByteBucket):PutString(StringConstant:CRLF).
        
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
        define variable errMsg as character no-undo.
        
        assign oMessageBody = ByteBucket:Instance()
               oBodyWriter  = BodyWriterBuilder
                                :Build(poRequest)
                                :WriteTo(oMessageBody)
                                :Writer.
        // We are extremely unlikely to not return a body writer, since spec says to use applicaiton/octet-stream
        // but we want some sane error handlings here so that we don't get 'invalid handle' errors from the Open() line
        if not valid-object(oBodyWriter) then
        do:
            assign errMsg = substitute('Unable to build request for transmission: no builder available for Content-Type: &1',
                                            poRequest:ContentType).
            Logger:Error(errMsg).
            return error new AppError(errMsg, 0).
        end.
        
        oBodyWriter:Open().
        /* writes the message's entity contents into a byte bucket */
        assign iBytesWritten = oBodyWriter:Write(poRequest:Entity).
        oBodyWriter:Close().
        
        /* Update the character encoding from the extraction */
        if type-of(oBodyWriter, ISupportEncoding) then
            assign poRequest:CharacterEncoding = cast(oBodyWriter, ISupportEncoding):Encoding.
            
        if type-of(oBodyWriter, ISupportMultipartEntity) then
            poRequest:GetHeader('Content-Type':u)
                     :SetParameterValue('boundary':u, cast(oBodyWriter, ISupportMultipartEntity):Boundary).
        
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
        define variable oProxyRequest as ISupportProxy no-undo.
        
        if type-of(poRequest, IAdaptable) then
            assign oProxyRequest = cast(cast(poRequest, IAdaptable):GetAdapter(get-class(ISupportProxy)), ISupportProxy).
        else
        if type-of(poRequest, ISupportProxy) then
            assign oProxyRequest = cast(poRequest, ISupportProxy).
        
        if valid-object(oProxyRequest) and
           valid-object(oProxyRequest:ProxyURI) then
            /* for proxies, we want http://example.com/some/data?query=true */
            assign cRequestURI = poRequest:URI:Encode().
        else
            /* for normal request, we want /some/data?query=true */
            assign cRequestURI = poRequest:URI:Path + poRequest:URI:EncodeQuery().
        
        cast(this-object:Entity, ByteBucket):PutString(substitute('&1 &2 &3':u,
                                caps(poRequest:Method),
                                cRequestURI,
                                poRequest:Version ) + StringConstant:CRLF).
    end method.
    
    /** Writes the HTTP headers into the bucket 
        
        @param ByteBucket The target for the write operation */
    method protected void WriteHeaders(input poRequest as IHttpRequest):
        define variable iLoop as integer no-undo.
        define variable oHeader as HttpHeader extent no-undo.
        
        do iLoop = poRequest:GetHeaders(output oHeader) to 1 by -1:
            cast(Entity, ByteBucket):PutString(substitute('&1&2':u,
                                    oHeader[iLoop]:ToString(),
                                    StringConstant:CRLF)).
        end.    /* header */
        
        /* ACCEPT */
        if not poRequest:HasHeader('Accept':u) then
            /* Default to all. */
            cast(Entity, ByteBucket):PutString('Accept: */*':u + StringConstant:CRLF).
        
        /* TRANSFER ENCODING */
        if not poRequest:TransferEncoding eq string(TransferEncodingEnum:None) then
            cast(Entity, ByteBucket):PutString(substitute('Accept-Encoding: &1&2':u,
                                            lc(poRequest:TransferEncoding),
                                            StringConstant:CRLF)).
    end method.
    
end class.
