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
using OpenEdge.Core.HashAlgorithmEnum.
using OpenEdge.Core.Memptr.
using Progress.Lang.AppError.

class OpenEdge.Core.Memptr:
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
            return new Memptr(1).
        end get.
    
    constructor protected Memptr():
        assign AutoDestroy = true
               ExternalAllocation = false.
    end constructor.
    
    /** Constructor.
    
        @param int64 The pointer to memory represented by a memptr (via get-pointer-value). 
        @param int64 The size of the memptr represented by the pointer value. */          
    constructor public Memptr(input piPtr as int64, input piSize as int64):
        this-object(piSize).
        
        set-pointer-value(mmValue) = piPtr.
        
        /* this is an externally-managed memptr. Caller is responsible for cleanup. */
        assign ExternalAllocation = true.
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
        do:
            /* externally-allocated memptrs must let go of the pointer and THEN
               set size to zero */
            if this-object:ExternalAllocation then
                set-pointer-value(mmValue) = 0.
            
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
            assign iOldSize = this-object:Size
                   set-size(mmValue) = 0
                   set-size(mmValue) = iOldSize.
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
        return message-digest(poAlgorithm:Name, mmValue).
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
        return GetString(piStartPos, piSliceSize, 'UTF-8':u).
    end.
        
    /** Returns a string/character representation a particular number of bytes,
        from a given start position.
    
        @param  int64 The start potision
        @param  int64 The size of the data (in bytes) to return 
        @param  character The codepage for the character data
        @return longchar The character/string data requested     */
    method public longchar GetString(input piStartPos as int64,
                                     input piSliceSize as int64,
                                     input pcCodepage as character):
        define variable lcData as longchar no-undo.

        Assert:IsPositive(piStartPos, 'Start position').
        Assert:IsZeroOrPositive(piSliceSize, 'Slice size').
        Assert:NotNullOrEmpty(pcCodepage, 'Codepage').
        
        fix-codepage(lcData) = pcCodepage.
        
        /* return an empty string */        
        if this-object:Size eq 0 then
            return '':u.
        
        assign lcData = get-string(mmValue, piStartPos, piSliceSize).
        
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
        if this-object:Size eq 0 then
            oSlice = new Memptr(1).
        else
        do:            
            set-size(mSlice) = piSliceSize.
            
            mSlice = get-bytes(mmValue, piStartPos, piSliceSize).
            oSlice = new Memptr(mSlice).
        end.
                
        return oSlice.
        finally:
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
        
        if piSize gt this-object:Size then
            return error new AppError('Input memptr larger than available size', 0).
        
        set-size(mTemp) = piSize.
        set-pointer-value(mTemp) = piPointerValue.
        
        put-bytes(mmValue, 1) = get-bytes(mTemp, 1, piSize).
        
        finally:
            set-pointer-value(mTemp) = piPointerValue.
            set-size(mTemp) = piSize.
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
    
    method public void _Debug():
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iByte as integer no-undo.
        define variable cDumpFile as character no-undo.
        
        if not session:debug-alert then
            return.
        
        iMax = get-size(mmValue).
        cDumpFile = session:temp-directory + this-object:ToString() + '.txt':u.
        
        if log-manager:logfile-name ne ? and
           log-manager:logging-level gt 1 then
            log-manager:write-message('DEBUG FILE=':u + cDumpFile, 'MEMPTR':u).
        
        output to value(cDumpFile).
        do iLoop = 1 to iMax:
            iByte = get-byte(mmValue, iLoop).
            
            put unformatted 
                iByte '~t':u .
                
            if iByte <> 10 and iByte <> 13 then
                put unformatted
                 '~t~t':u chr(iByte).
                  
             put unformatted skip. 
        end.
        output close.

    end method.
                   
end class.
