 /************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : BinaryEntityWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : - Write() operations are NOT destructive
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.ISupportTransferEncoding.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.BinaryEntityWriter inherits MessageWriter
            implements ISupportTransferEncoding:

    /* Transfer encoding (eg base63 or binary or 7bit or 8bit etc ) used by the implementer */      
    define public property TransferEncoding as character no-undo get. set.

    
    constructor public BinaryEntityWriter():
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
    
    method override public int64 Write(input poData as Object):
        Assert:NotNull(poData).
        
        if type-of(poData, Memptr) then
            cast(Entity, ByteBucket):PutBytes(
                                cast(poData, Memptr):GetPointerValue(), 
                                cast(poData, Memptr):Size ).
        else
        if type-of(poData, ByteBucket) then
            cast(Entity, ByteBucket):PutBytes(cast(poData, ByteBucket)).
        else
        if type-of(poData, String) then
            cast(Entity, ByteBucket):PutString(cast(poData, String)).            
        else
            return error new AppError(
                            substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                            , 0).
        
        return dynamic-property(poData, 'Size':u).
    end method.
    
    method override public int64 Write(input pcData as longchar):
        define variable mData as memptr no-undo.
        
        Assert:NotNull(pcData, 'Data').
        
        set-size(mData) = length(pcData, 'RAW':u) + 1.
        put-string(mData,1) = pcData.
        
        return this-object:Write(mData).
        finally:
            set-size(mData) = 0.
        end finally.
    end method.

    method override public int64 Write(input pmData as memptr):
        define variable iBytesWritten as int64 no-undo.
        
        assign iBytesWritten = get-size(pmData).
        Assert:IsZeroOrPositive(iBytesWritten, 'Data size').
        
        if iBytesWritten gt 0 then
            cast(Entity, ByteBucket):PutBytes(get-pointer-value(pmData),
                                              get-size(pmData)). 
        return iBytesWritten.
    end method.
    
    /** Write data to/from the message

        @param character Data to write */
    method override public int64 Write(input pcData as character):
        define variable mData as memptr no-undo.
        
        Assert:NotNull(pcData, 'Data').
        
        set-size(mData) = length(pcData, 'RAW':u) + 1.
        put-string(mData,1) = pcData.
        
        return this-object:Write(mData).
        finally:
            set-size(mData) = 0.
        end finally.
    end method.    
    
end class.