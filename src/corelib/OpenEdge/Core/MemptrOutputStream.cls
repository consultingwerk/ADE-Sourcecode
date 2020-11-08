/* *************************************************************************************************************************
Copyright (c) 2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MemptrOutputStream
    Description : An OutputStream implementation that holds data in-memory. 
    Author(s)   : pjudge
    Created     : 2019-02-20
    Notes       : * This should be replaced in 12.0.0+ with the Progress.IO.MemoryOutputStream, for performance reasons
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ByteBucket.
using Progress.IO.OutputStream.

class OpenEdge.Core.MemptrOutputStream inherits OutputStream:
    define private variable mBucket as ByteBucket no-undo.
    
    /* The JSON data that is created from this data target */
    define public property Data as memptr no-undo
        get.
        private set.
    
    /* Default constructor */
    constructor public MemptrOutputStream():
        super().
        
        assign mBucket = ByteBucket:Instance().
    end constructor.
    
    method override public void Flush():
        super:Flush().
        
        assign this-object:Data = mBucket:GetBytes():Value.
        mBucket:Clear().
    end method.
    
    method override public int64 Write(input pData as memptr,
                                       input pSkip as int64,
                                       input pBytes as int64 ):
        define variable mData as memptr no-undo.
        
        set-size(mData) = pBytes.
        assign mData = get-bytes(pData, pSkip, pBytes).
        
        mBucket:PutBytes(get-pointer-value(mData), get-size(mData)).
        
        return pBytes.
        finally:
            set-size(mData) = 0.
        end finally.
    end method.
    
    method override public int64 Write(input pData as memptr):
        mBucket:PutBytes(get-pointer-value(pData), get-size(pData)).
        return get-size(pData).
    end method.
    
    method override public int64 Write( input pData as longchar):
        mBucket:PutString(pData).
        return length(pData, 'raw':u).
    end method.
    
    method override public int64 Write( input pData as character):
        mBucket:PutString(pData).
        return length(pData, 'raw':u).
    end method.
    
end class.
