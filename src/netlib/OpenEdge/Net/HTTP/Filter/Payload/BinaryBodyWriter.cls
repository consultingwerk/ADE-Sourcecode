/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : BinaryBodyWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.ISupportTransferEncoding.
using Progress.IO.FileInputStream.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.BinaryBodyWriter inherits MessageWriter
            implements ISupportTransferEncoding: 

    /* Transfer encoding (eg base63 or binary or 7bit or 8bit etc ) used by the implementer */        
    define public property TransferEncoding as character no-undo get. set.

    constructor public BinaryBodyWriter():
        super(get-class(ByteBucket)).
    end constructor.
    
    /** Opens the writer for output. Open/Close allows us to write the same message multiple
        times without requiring a new writer each time. */
    method override public void Open():
        /* If nothing's passed in, use a bucket of our own. 
           Don't do this in the constructor as a micro-optimisation (yes, I know) */
        if not valid-object(this-object:Entity) then
            assign this-object:Entity = ByteBucket:Instance().
            
        super:Open().
    end method.
    
    method override public int64 Write(input pData as longchar):       
        cast(this-object:Entity, ByteBucket):PutString(pData).
        
        return length(pData, 'raw':u).
    end method.
    
    method override public int64 Write(input pData as memptr):
        cast(this-object:Entity, ByteBucket):PutBytes(get-pointer-value(pData), 
                                                      get-size(pData)).
        
        return get-size(pData).
    end method.
    
    method override public int64 Write( input poData as Object):
        define variable lcData as longchar no-undo.
        define variable bytesWritten as int64 no-undo.
        define variable mData as memptr no-undo.
        define variable fileStream as FileInputStream no-undo.
        
        assign this-object:TransferEncoding = 'binary':u.
        
        case true:
            when not valid-object(poData) then
                return 0.
                
            when type-of(poData, Memptr) or
            when type-of(poData, IMemptrHolder) then
            do on error undo, throw:
                // choose Write(<MEMPTR>) at compile time
                assign mData = dynamic-property(poData, 'Value':u).
                
                return this-object:Write(mData).
                finally:
                    if get-size(mData) gt 0 then
                        set-size(mData) = 0.
                end finally.
            end.
            
            when type-of(poData, ByteBucket) then
                cast(this-object:Entity, ByteBucket):PutBytes(cast(poData, ByteBucket)).            
            
            when type-of(poData, OpenEdge.Core.String) or
            when type-of(poData, ICharacterHolder) or
            when type-of(poData, ILongcharHolder) then
            do:
                // coerce into using the LONGCHAR version
                assign lcData = dynamic-property(poData, 'Value':u).
                
                // longchars are passed by-value, so don't do that
                cast(this-object:Entity, ByteBucket):PutString(lcData).                
                return length(lcData, 'raw':u).
            end.    // characters
            
            when type-of(poData, FileInputStream) then
                return WriteFileStream(cast(poData, FileInputStream)). 
            
            otherwise 
                return error new AppError(
                                substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                                , 0).
        end case.
        
        return bytesWritten.
    end method.
    
end class.