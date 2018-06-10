/************************************************
Copyright (c)  2015, 2018 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.StringConstant.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.ISupportMultipartEntity.
using OpenEdge.Net.MessagePart.
using OpenEdge.Net.MultipartEntity.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.MultipartBodyWriter inherits MessageWriter
        implements ISupportMultipartEntity:
    
    /** The character string delimiting the parts. Excludes the leading and trailing -- */
    define public property Boundary as character no-undo get. set. 
    
    define private variable mlExternalEntity as logical no-undo.

    constructor public MultipartBodyWriter():
        super(get-class(ByteBucket)).
        
        assign this-object:Boundary = guid.
    end constructor.
    
    method override public void Open():
        assign mlExternalEntity = valid-object(this-object:Entity).
        if not mlExternalEntity then
            assign this-object:Entity = ByteBucket:Instance().
        
        super:Open().
    end method.

    method override public int64 Write(input pData as Object):
        case true:
            when not valid-object(pData) then
                return 0.
            
            when type-of(pData, MultipartEntity) then
                return this-object:Write(cast(pData, MultipartEntity)).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
        return 0.
    end method.
    
    method protected int64 Write(input pData as MultipartEntity):
        define variable oPart as ByteBucket no-undo.
        define variable oMessagePart as MessagePart no-undo.
        define variable iLoop as integer no-undo.
        define variable iBytesBefore as int64 no-undo.
        define variable oPartWriter as MessageWriter no-undo.
        define variable oHeaders as HttpHeader extent no-undo.
        define variable iHeaderLoop as integer no-undo.
        define variable boundaryString as character no-undo.
        
        Assert:NotNull(pData, 'Multipart entity').
        
        assign iBytesBefore         = cast(this-object:Entity, ByteBucket):Size
               /* make sure we set our boundary */
               this-object:Boundary = pData:Boundary
               oPart                = ByteBucket:Instance()
               boundaryString       = substitute('--&1&2':u, this-object:Boundary, StringConstant:CRLF)
               .
        /* PROLOGUE */
        if pData:Prologue ne '':u then                
            cast(this-object:Entity, ByteBucket):PutString(pData:Prologue + StringConstant:CRLF).
        
        /* DATA PARTS */
        do iLoop = 1 to pData:Size:
            oPart:Clear().            
            cast(this-object:Entity, ByteBucket):PutString(boundaryString).
            
            /* now write the content */
            assign oMessagePart = pData:GetPart(iLoop)
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
                                            StringConstant:CRLF)).
            end.    /* header */
            cast(this-object:Entity, ByteBucket):PutString(StringConstant:CRLF).
            
            /* write part content to MessageBody */
            cast(this-object:Entity, ByteBucket):PutBytes(oPart).
            cast(this-object:Entity, ByteBucket):PutString(StringConstant:CRLF).
        end.
        
        /* EPILOGUE: content/data done */
        cast(this-object:Entity, ByteBucket):PutString(substitute('--&1--&2':u, this-object:Boundary, StringConstant:CRLF)).
        
        if pData:Epilogue ne '':u then
            cast(this-object:Entity, ByteBucket):PutString(pData:Epilogue).
        else
        /* if this is a nested multipart entity (ie a part in another multipart entity, then
           we don't need to add a CRLF, since the parent will do it for us, as part of adding 
           the part.
           
           if we are the outermost/un-parented entity, then add a final CRLF */
        if not mlExternalEntity then
            cast(this-object:Entity, ByteBucket):PutString(StringConstant:CRLF).
        
        return (cast(this-object:Entity, ByteBucket):Size - iBytesBefore).
    end method.
    
end class.