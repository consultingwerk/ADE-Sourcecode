/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : MultipartFormBodyWriter
    Purpose     : Writes a Map as a multipart/form-data body 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-03-13
    Notes       : * multipart/form-data defined in https://tools.ietf.org/html/rfc7578 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.Collections.Map.
using OpenEdge.Core.ISupportEncoding.
using OpenEdge.Core.String.
using OpenEdge.Core.StringConstant.
using OpenEdge.Net.FileTypeRegistry.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.BodyWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.ISupportMultipartEntity.
using OpenEdge.Net.MessagePart.
using OpenEdge.Net.MultipartEntity.
using Progress.IO.FileInputStream.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.MultipartFormBodyWriter inherits MessageWriter
        implements ISupportMultipartEntity, ISupportEncoding:
    
    /* The character string delimiting the parts. Excludes the leading and trailing -- */
    define public property Boundary as character no-undo get. set. 
    
    /* Content encoding (eg utf-8) used by the implementer */ 
    define public property Encoding as character no-undo get. set.
    
    define private variable mlExternalEntity as logical no-undo.
    
    /* Default constructor */
    constructor public MultipartFormBodyWriter():
        super(get-class(ByteBucket)).
        
        assign this-object:Boundary = guid.
    end constructor.
    
    method override public void Open():
        assign mlExternalEntity = valid-object(this-object:Entity).
        if not mlExternalEntity then
            assign this-object:Entity = ByteBucket:Instance().
        
        super:Open().
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
    
    method override public int64 Write(input pData as Object):
        case true:
            when not valid-object(pData) then
                return this-object:Write(new Map()).
            
            when type-of(pData, IMap) then
                return this-object:Write(cast(pData, IMap)).
            
            when type-of(pData, MultipartEntity) then
                return this-object:Write(cast(pData, MultipartEntity)).
            
            otherwise
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
        
        return 0.
    end method.
    
    /* Writes a Map/Dictionary as form data (since a map has key-value pairs).
       
       @param IMap A map for form fields and their values
       @return int64 The number of bytes written */
    method protected int64 Write(input pData as IMap):
        define variable bytesBefore as int64 no-undo.
        define variable iterator as IIterator no-undo.
        define variable mapEntry as IMapEntry no-undo.
        define variable boundaryString as character no-undo.
        
        // make sure we have a boundary.
        if String:IsNullOrEmpty(this-object:Boundary) then
            assign this-object:Boundary = guid.
        
        assign bytesBefore    = cast(this-object:Entity, ByteBucket):Size
               boundaryString = substitute('--&1&2':u, this-object:Boundary, StringConstant:CRLF)
               .
        // if there's an Encoding set in this writer, write it into a field part
        if this-object:Encoding ne '':u then
            WriteField(new String('_charset_':u), new String(this-object:Encoding)).
        
        // now write the individual parts
        assign iterator = pData:EntrySet:Iterator().
        do while iterator:HasNext():
            assign mapEntry = cast(iterator:Next(), IMapEntry).
            // opening boundary
            cast(this-object:Entity, ByteBucket):PutString(boundaryString).
            // field value
            this-object:WriteField(mapEntry:Key, mapEntry:Value).
        end.
        
        /* Content/data done */
        cast(this-object:Entity, ByteBucket):PutString(substitute('--&1--&2':u, this-object:Boundary, StringConstant:CRLF)).
        
        /* if this is a nested multipart entity (ie a part in another multipart entity, then
           we don't need to add a CRLF, since the parent will do it for us, as part of adding 
           the part.
           
           if we are the outermost/un-parented entity, then add a final CRLF */
        if not mlExternalEntity then
            cast(this-object:Entity, ByteBucket):PutString(StringConstant:CRLF).
        
        return (cast(this-object:Entity, ByteBucket):Size - bytesBefore).
    end method.
    
    /* Writes a form 'field' as a part 
       @param Object The part name (the key)
       @param Object The part value */    
    method protected void WriteField(input pKey as Object,
                                     input pValue as Object):
        define variable msgPart as ByteBucket no-undo.
        define variable partWriter as MessageWriter no-undo.
        define variable contentType as character no-undo.
        define variable fileName as character no-undo.
        define variable chrPos as integer no-undo.
        define variable hdrContentDisp as HttpHeader no-undo.
        
        Assert:NotNull(pKey, 'Form field name').
        
        assign msgPart        = ByteBucket:Instance()
               hdrContentDisp = HttpHeaderBuilder:Build('Content-Disposition':u)
                                    :Value('form-data':u)
                                    :Header
               .
        /* now write the content */
        hdrContentDisp:SetParameterValue('name':u, StringConstant:DOUBLE_QUOTE + pKey:ToString() + StringConstant:DOUBLE_QUOTE).
        
        case true:
            when not valid-object(pValue)          or 
            when type-of(pValue, ILongcharHolder)  or
            when type-of(pValue, ICharacterHolder) then  
                assign contentType = 'text/plain':u.
            
            when type-of(pValue, FileInputStream) then
            do:
                // we know it's a file, but not what type of file
                assign fileName    = replace(cast(pValue, FileInputStream):FileName, StringConstant:BACKSLASH, '/':u)
                       chrPos      = r-index(fileName, '/':u)
                       filename    = substring(fileName, chrPos + 1)
                       // default content type from the file extension
                       contentType = FileTypeRegistry:Registry:Get(entry(num-entries(filename, '.':u), filename, '.':u)) 
                       .
                if contentType eq '':u then
                    assign contentType = 'application/octet-stream':u.
                
                hdrContentDisp:SetParameterValue('filename':u, StringConstant:DOUBLE_QUOTE + fileName + StringConstant:DOUBLE_QUOTE).
            end.
            
            // some form of binary file ()
            when type-of(pValue, IMemptrHolder) or
            when type-of(pValue, ByteBucket)    then
                assign contentType = 'application/octet-stream':u.
            
            //default content-type
            otherwise
                assign contentType = 'text/plain':u.
        end case.
        
        /* write Content-Disposition headers to MessageBody */
        cast(this-object:Entity, ByteBucket):PutString(substitute('&1&2':u, 
                                    hdrContentDisp:ToString(),
                                    StringConstant:CRLF)).
        //nothing else to write 
        if valid-object(pValue) then
        do:
            assign partWriter = BodyWriterBuilder:Build(contentType)
                                     :WriteTo(msgPart)
                                     :Writer.
            Assert:NotNull(partWriter, 'Part writer').
            
            partWriter:Open().
            partWriter:Write(pValue).
            partWriter:Close().
            
            /* write Content-Type headers to MessageBody */
            cast(this-object:Entity, ByteBucket):PutString(substitute('&1&2':u, 
                                        HttpHeaderBuilder:Build('Content-Type':u):Value(contentType):Header:ToString(),
                                        StringConstant:CRLF)).
            cast(this-object:Entity, ByteBucket):PutString(StringConstant:CRLF).
            
            /* write part content to MessageBody */
            cast(this-object:Entity, ByteBucket):PutBytes(msgPart).
        end.
        else
            // nothing to write; end the headers section
            cast(this-object:Entity, ByteBucket):PutString(StringConstant:CRLF).
        
        // end the part
        cast(this-object:Entity, ByteBucket):PutString(StringConstant:CRLF).
    end method.
    
end class.
