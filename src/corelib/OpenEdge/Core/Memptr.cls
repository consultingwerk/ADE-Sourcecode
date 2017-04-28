/************************************************
Copyright (c) 2014-2017 by Progress Software Corporation. All rights reserved.
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

using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.HashAlgorithmEnum.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.StringConstant.
using Progress.Lang.AppError.

class OpenEdge.Core.Memptr implements IMemptrHolder:
    /**  the actual memptr under management here */
    define private variable mmValue as memptr no-undo.
    
    /** Indicates whether the memptr will be destroyed/cleared when this object
        is destroyed. Default is TRUE. */
    define public property AutoDestroy as logical initial true no-undo get. set.
    
    /** indicates whether the memory is being managed by  */
    define public property ExternalAllocation as logical no-undo get. private set.
    
    /** A public representation of the memptr. */
    define public property Value as memptr no-undo
        get():
            return mmValue.
        end get.
    
    /** The size of the current memptr */
    define public property Size as int64 no-undo
        get():
            return get-size(mmValue). 
        end get.
        set(input piSize as int64):
            if get-size(mmValue) eq 0 then
                set-size(mmValue) = piSize.
        end set.
    
    /** Returns a new, empty/null Memptr */
    define static public property Empty as class Memptr no-undo
        get().
            return new Memptr(0).
        end get.
    
    constructor protected Memptr():
        assign AutoDestroy = true
               ExternalAllocation = false.
    end constructor.
    
    /** Constructor.
    
        @param int64 The pointer to memory represented by a memptr (via get-pointer-value). 
        @param int64 The size of the memptr represented by the pointer value. */          
    constructor public Memptr(input piPtr as int64, input piSize as int64):
        /* this-object(piSize). - don't use this constructor, it calls set-size() */
        this-object().
        /* copy of code from this-object(size) constructor */
        Assert:IsZeroOrPositive(piSize, 'Size').
        set-pointer-value(mmValue) = piPtr.
        set-size(mmValue) = piSize.
        
        /* this is an externally-managed memptr. Caller is responsible for cleanup. */
        assign ExternalAllocation = true.
    end constructor.
    
    /** Constructor.
    
        @param int64 The size of the memptr to be created. */          
    constructor public Memptr(input piSize as int64):
        this-object().
        
        Assert:IsZeroOrPositive(piSize, 'Size').
        set-size(mmValue) = piSize.
    end constructor.
    
    /** Deep copy/clone of the input memptr. Caller is responsible for cleanup. */
    constructor public Memptr(input pmValue as memptr):
        this-object(get-size(pmValue)).
        
        if get-size(pmValue) gt 0 then 
            put-bytes(mmValue, 1) = pmValue.
    end constructor.
    
    /** Deep copy/clone of the input memptr. */
    constructor public Memptr(input prValue as raw):
        this-object(length(prValue)).
        
        if length(prValue) gt 0 then
            put-bytes(mmValue, 1) = prValue.
    end constructor.
    
    destructor public Memptr():
        if this-object:AutoDestroy then
        do:
            /* externally-allocated memptrs must let go of the pointer and THEN
               set size to zero */
            if this-object:ExternalAllocation then
                set-pointer-value(mmValue) = 0.
            if get-size(mmValue) gt 0 then
                set-size(mmValue) = 0.
        end.            
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
        if not this-object:ExternalAllocation then
        do:
            assign iOldSize = this-object:Size.
            if get-size(mmValue) gt 0 then
                set-size(mmValue) = 0.
            set-size(mmValue) = iOldSize.
        end.
    end method.
    
    /** Returns a hash of the current contents of the memptr. This can be used
        for comparing memptr values quickly.  
        
        @return raw The hashed value of the memptr. */
    method public raw GetHash():
        return GetHash(HashAlgorithmEnum:MD5).
    end method.

    /** Returns a hash of the current contents of the memptr. This can be used
        for comparing memptr values quickly.  
        
        @param HashAlgorithmEnum The algorithm to use for the message
        @return raw The hashed value of the memptr. */
    method public raw GetHash(input poAlgorithm as HashAlgorithmEnum):
        Assert:NotNull(poAlgorithm, 'Algorithm').
        return message-digest(string(poAlgorithm), mmValue).
    end method.
    
    /** Returns a byte at the specified position
        
        @param int64 The position at which to return the byte.
        @return integer The byte value at the current position */
    method public integer GetByte(input piPos as int64):        
        Assert:IsPositive(piPos, 'Position').
        
        return get-byte(mmValue, piPos).        
    end method.

    /** Returns a string/character representation from a given start position,
        for the remainder of the data.
    
        @param  int64 The start potision
        @return longchar The character/string data requested     */
    method public longchar GetString(input piStartPos as int64):
        return GetString(piStartPos, this-object:Size - piStartPos).
    end.

    /** Returns a string/character representation a particular number of bytes,
        from a given start position.
    
        @param  int64 The start potision
        @param  int64 The size of the data (in bytes) to return 
        @return longchar The character/string data requested     */
    method public longchar GetString(input piStartPos as int64,
                                     input piSliceSize as int64):
        return GetString(piStartPos, piSliceSize, session:cpinternal, 'UTF-8':u).
    end.
        
    /** Returns a string/character representation a particular number of bytes,
        from a given start position.
        
        @param  int64 The start potision
        @param  int64 The size of the data (in bytes) to return 
        @param  character The target codepage for the character data
        @return longchar The character/string data requested     */
    method public longchar GetString(input piStartPos as int64,
                                     input piSliceSize as int64,
                                     input pcTargetCodepage as character):
        return GetString(piStartPos, piSliceSize, session:cpinternal, pcTargetCodepage).                                         
    end method.
    
    /** Returns a string/character representation a particular number of bytes,
        from a given start position.
    
        @param  int64 The start potision
        @param  int64 The size of the data (in bytes) to return 
        @param  character The source codepage for the character data
        @param  character The target codepage for the character data
        @return longchar The character/string data requested     */
    method public longchar GetString(input piStartPos as int64,
                                     input piSliceSize as int64,
                                     input pcSourceCodepage as character,
                                     input pcTargetCodepage as character):
        define variable lcData as longchar no-undo.

        Assert:IsPositive(piStartPos, 'Start position').
        Assert:IsZeroOrPositive(piSliceSize, 'Slice size').
        Assert:NotNullOrEmpty(pcSourceCodepage, 'Source codepage').
        Assert:NotNullOrEmpty(pcTargetCodepage, 'Target codepage').
        
        fix-codepage(lcData) = pcTargetCodepage.
        
        if this-object:Size gt 0 then
            copy-lob from mmValue starting at piStartPos for piSliceSize
                     to lcData
                     convert
                        source codepage pcSourceCodepage 
                        target codepage pcTargetCodepage.
        
        return lcData.        
    end method.
    
    /** Returns a Memptr instance containing the specified number of bytes,
        starting at the current Position.
        
        @param int64 The number of bytes to return
        @return Memptr The complete data */
    method public class Memptr GetBytes(input piStartPos as int64):
        Assert:IsPositive(piStartPos, 'Start position').
        
        return GetBytes(piStartPos, this-object:Size - piStartPos).
    end method.
    
    /** Returns a Memptr instance containing the specified number of bytes,
        starting at the specified postition.
    
        @param int64 The starting position
        @param int64 The number of bytes to return
        @return Memptr The complete bucket data */
    method public class Memptr GetBytes(input piStartPos as int64,
                                        input piSliceSize as int64):
        define variable mSlice as memptr no-undo.
        define variable oSlice as class Memptr no-undo.
        
        Assert:IsPositive(piStartPos, 'Start position').
        Assert:IsPositive(piSliceSize, 'Slice size').
        
        /* return an empty Memptr */
        if    this-object:Size eq 0 
           or piSliceSize eq 0 then
            oSlice = new Memptr(0).
        else
        do:
            set-size(mSlice) = piSliceSize.
            
            assign mSlice = get-bytes(mmValue, piStartPos, piSliceSize)
                   oSlice = new Memptr(mSlice).
        end.
        
        return oSlice.
        finally:
            if get-size(mSlice) gt 0 then
                set-size(mSlice) = 0.
        end finally.
    end method.
    
    /** Copies all of the bytes from a memptr into this memptr. The
        caller is responsible for cleaning up the memptr.
    
        @param int64 The pointer to memory represented by a memptr (via get-pointer-value). 
        @param int64 The size of the memptr represented by the pointer value. */
    method public void PutBytes(input piPointerValue as int64,
                                input piSize as int64):
        define variable iLoop as integer no-undo.
        define variable mTemp as memptr no-undo.
        
        Assert:IsZeroOrPositive(piPointerValue, 'Pointer').
        Assert:IsZeroOrPositive(piSize, 'Size').
        
        if this-object:Size eq 0 then
           assign this-object:Size = piSize.
        else  
        if piSize gt this-object:Size then
            return error new AppError('Input memptr larger than available size', 0).
        
        set-size(mTemp) = 1. 
        set-size(mTemp) = 0. 
        set-pointer-value(mTemp) = piPointerValue.
        set-size(mTemp) = piSize.
        
        put-bytes(mmValue, 1) = mTemp.
        
        finally:
            set-pointer-value(mTemp) = 0.
            if get-size(mTemp) gt 0 then
                set-size(mTemp) = 0.
        end finally.
    end method.
    
    /** Copies all of the bytes from a memptr (primitive) into this bucket. The
        caller is responsible for cleaning up the memptr. 
    
        @param memptr The memptr containing the data. */
    method public void PutBytes(input pmData as memptr):
        /* jiggery-pokery so we can reuse code without deep-copying 
           memptr's all over the show */
        PutBytes(get-pointer-value(pmData), get-size(pmData)).
    end method.
    
    /** Copies all of the bytes from a raw into this memptr. 
        
        @param raw The raw variable containing the source data */
    method public void PutBytes(input prData as raw):
        define variable mData as memptr no-undo.
        
        set-size(mData) = length(prData).
        put-bytes(mData,1) = prData.
        
        PutBytes(get-pointer-value(mData), get-size(mData)).
        
        finally:
            if get-size(mData) gt 0 then
                set-size(mData) = 0.
        end finally.
    end method.
    
    /** Debug/dump of the contents of this object on a per-byte basic. COPY-LOB 
        can also be used for debug purposes (COPY-LOB objMemptr:Value TO FILE). */
    method public void _Debug ():
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iByte as integer no-undo.
        define variable cDumpFile as character no-undo.
        
        assign iMax      = get-size(mmValue)
               cDumpFile = session:temp-directory + this-object:ToString() + '.bin':u.
        
        output to value(cDumpFile).
        do iLoop = 1 to iMax:
            assign iByte = get-byte(mmValue, iLoop).
            
            put unformatted 
                iByte StringConstant:TAB.
                
            if iByte <> 10 and iByte <> 13 then
                put unformatted
                    StringConstant:TAB StringConstant:TAB chr(iByte).
                  
             put unformatted skip. 
        end.
        output close.
    end method.
    
    method override public character ToString():
        return substitute('&1_&2':u, this-object:GetClass():TypeName, get-pointer-value(mmValue)).
    end method.
    
end class.
