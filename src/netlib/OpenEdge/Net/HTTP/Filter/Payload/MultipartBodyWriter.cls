/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MultipartBodyWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.ISupportMultipartEntity.
using OpenEdge.Net.MessagePart.
using OpenEdge.Net.MultipartEntity.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.MultipartBodyWriter inherits MessageWriter
        implements ISupportMultipartEntity:
    
    /** The character string delimiting the parts. Excludes the leading and trailing -- */
    define public property Boundary as character no-undo get. set. 
    
    define private variable mlExternalEntity as logical no-undo.

    /* private and immutable constant value */
    define protected property CRLF as character initial '~r~n':u no-undo get.
    
    constructor public MultipartBodyWriter():
        super(get-class(ByteBucket)).
    end constructor.
    
    method override public void Open():
        assign mlExternalEntity = valid-object(this-object:Entity).
        if not mlExternalEntity then
            assign this-object:Entity = ByteBucket:Instance().
        
        super:Open().
    end method.

    method override public int64 Write(input poData as Object):
        define variable oPart as ByteBucket no-undo.
        define variable oMessagePart as MessagePart no-undo.
        define variable oMultipartEntity as MultipartEntity no-undo.
        define variable iLoop as integer no-undo.
        define variable iBytesBefore as int64 no-undo.
        define variable oPartWriter as MessageWriter no-undo.
        define variable cEncoding as character no-undo.
        define variable cPartBoundary as character no-undo.
        define variable oHeaders as HttpHeader extent no-undo.
        define variable iHeaderLoop as integer no-undo.
        
        Assert:IsType(poData, get-class(MultipartEntity)).

        assign iBytesBefore     = cast(this-object:Entity, ByteBucket):Size
               /* cast for convenience */
               oMultipartEntity = cast(poData, MultipartEntity)
               /* make sure we set our boundary */
               this-object:Boundary = oMultipartEntity:Boundary
               
               oPart = ByteBucket:Instance()
               .
        
        /* PROLOGUE */
        if oMultipartEntity:Prologue ne '':u then                
            cast(this-object:Entity, ByteBucket):PutString(oMultipartEntity:Prologue + CRLF).
        
        /* DATA PARTS */
        do iLoop = 1 to oMultipartEntity:Size:
            oPart:Clear().            
            cast(this-object:Entity, ByteBucket):PutString(substitute('--&1&2':u, oMultipartEntity:Boundary, CRLF)).
            
            /* now write the content */
            assign oMessagePart = oMultipartEntity:GetPart(iLoop)
                   oPartWriter  = BodyWriterBuilder:Build(oMessagePart)
                                     :WriteTo(oPart)
                                     :Writer.
            Assert:NotNull(oPartWriter, 'Part writer').
            
            oPartWriter:Open().
            oPartWriter:Write(oMessagePart:Body).
            oPartWriter:Close().
            
            /* write part headers to MessageBody */
            assign extent(oHeaders) = ?.
            do iHeaderLoop = oMessagePart:Headers:GetAll(output oHeaders) to 1 by -1:
                cast(this-object:Entity, ByteBucket)
                    :PutString(substitute('&1&2':u, 
                                            oHeaders[iHeaderLoop]:ToString(),
                                            CRLF)).
            end.    /* header */
            cast(this-object:Entity, ByteBucket):PutString(CRLF).
            
            /* write part content to MessageBody */
            cast(this-object:Entity, ByteBucket):PutBytes(oPart).
            cast(this-object:Entity, ByteBucket):PutString(CRLF).
        end.
        
        /* EPILOGUE: content/data done */
        cast(this-object:Entity, ByteBucket):PutString(substitute('--&1--&2':u, oMultipartEntity:Boundary, CRLF)).
        
        if oMultipartEntity:Epilogue ne '':u then
            cast(this-object:Entity, ByteBucket):PutString(oMultipartEntity:Epilogue).
        else
        /* if this is a nested multipart entity (ie a part in another multipart entity, then
           we don't need to add a CRLF, since the parent will do it for us, as part of adding 
           the part.
           
           if we are the outermost/un-parented entity, then add a final CRLF */
        if not mlExternalEntity then
            cast(this-object:Entity, ByteBucket):PutString(CRLF).
        
        return (cast(this-object:Entity, ByteBucket):Size - iBytesBefore).
    end method.
    
end class.