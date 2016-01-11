/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : Memptr
    Purpose     : Object representation of an ABL primitive MEMPTR. 
    Author(s)   : pjudge
    Created     : Wed Apr 02 16:42:15 EDT 2014
    Notes       : * The constructor with the memptr input is a deep copy/clone 
                    of the input memptr. The caller is responsible for cleanup
                    of that input memptr. If a shallow copy is desired, then the
                    (size, pointer-value) constructor should be used.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.

class OpenEdge.Core.Memptr:
    /**  the actual memptr under management here */
    define private variable mmValue as memptr no-undo.
    
    /** Indicates whether the memptr will be destroyed/cleared when this object
        is destroyed. Default is TRUE. */
    define public property AutoDestroy as logical initial true no-undo get. set.
    
    /** A public representation of the memptr. */
    define public property Value as memptr no-undo
        get():
            return mmValue.
        end get.
        
    /** The size of the curremnt memptr */
    define public property Size as int64 no-undo
        get():
            return get-size(mmValue). 
        end get.
        set(input piSize as int64):
            if get-size(mmValue) eq 0 then
                set-size(mmValue) = piSize.
        end set.
    
    /** Constructor.
    
        @param int64 The pointer to memory represented by a memptr (via get-pointer-value). 
        @param int64 The size of the memptr represented by the pointer value. */          
    constructor public Memptr(input piPtr as int64, input piSize as int64):
        this-object(piSize).
        
        set-pointer-value(mmValue) = piPtr.
    end constructor.
    
    /** Constructor.
    
        @param int64 The size of the memptr to be created. */          
    constructor public Memptr(input piSize as int64):
        super().
        
        Assert:IsZeroOrPositive(piSize, 'Size').
        this-object:Size = piSize.
        set-size(mmValue) = piSize.
    end constructor.
    
    /** Deep copy/clone of the input memptr. Caller is responsible for cleanup. */
    constructor public Memptr(input pmValue as memptr):
        this-object(get-size(pmValue)).
        
        put-bytes(mmValue, 1) = pmValue.
    end constructor.
    
    destructor public Memptr():
        if this-object:AutoDestroy then
            set-size(mmValue) = 0.
    end destructor.
    
    /** Returns the pointer value of the current memptr.
    
        @param int64 The pointer to memory represented by this memptr */ 
    method public int64 GetPointerValue():
        define variable iPtr as int64 no-undo.
        
        iPtr = get-pointer-value(mmValue).
        return iPtr.
    end method.
    
    /** Clears/resets the current memptr. Clears the memory and resets it to
        its former size. */
    method public void Clear():
        define variable iOldSize as integer no-undo.
        
        assign iOldSize = this-object:Size
               set-size(mmValue) = 0
               set-size(mmValue) = iOldSize.
    end method.
    
end class.