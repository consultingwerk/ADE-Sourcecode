/************************************************
Copyright (c) 2014-2018 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ByteBucket
    Purpose     : An extensible bucket/container for byte-based data. The bucket
                  consists of a MemoryOutputSTream instance
    Author(s)   : pjudge
    Created     : Wed May 14 16:26:38 EDT 2014
    Notes       : * Bucket size is initially 3 x 30k records, and will expand
                    to contain whatever's passed in.
                  * Resize can be used to grow and shrink the number of rows in
                    the bucket. The number of rows cannot shrink below the number
                    needed to contain the current data (ie :Size ).
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.HashAlgorithmEnum.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.String.
using OpenEdge.Core.Util.MathUtil.
using Progress.Io.MemoryOutputStream.

class OpenEdge.Core.ByteBucket implements ISupportInitialize:
    
    define private variable memoutStream as Progress.Io.MemoryOutputStream no-undo.
    
    /** The current read position */
    define public property Position as int64 no-undo get. set.
    
    /* global/stateful variable to avoid deep copies of memptrs being passed internally/this class */
    define private variable mmTempBytes as memptr no-undo.
    
    /** The initial size of the memptr that are held in the Bucket */
    define public property DefaultCapacity as int64 no-undo get. private set.
    
    /** Returns the size of the data in the bucket */    
    define public property Size as int64 no-undo 
        get: 
            return memoutStream:BytesWritten. 
        end.
    
    /** Constructor for a ByteBucket. Defaults to 0 memptr size */
    constructor public ByteBucket():
        this-object(1).
        DefaultCapacity = 0.
    end method.
    
    /** Constructor for a ByteBucket
        @param int64 the intial size of memptr to store bytes */
    constructor public ByteBucket(input piDefaultCapacity as int64):
        memoutStream = New Progress.io.MemoryOutputStream(piDefaultCapacity).
        this-object:Position        =   1. 
        DefaultCapacity = piDefaultCapacity.
    end constructor.
    
    destructor ByteBucket():
        Destroy().
    end destructor.
    
    /** Constructor for a ByteBucket
        @deprecated(since='12.0':u).
        @param integer  The initial size of the array (ie how many extents)
        @param int64 the intial size of  memptr to store bytes */
    constructor public ByteBucket(input piInitialSize as integer, input piDefaultCapacity as int64):
        memoutStream = New Progress.io.MemoryOutputStream(piDefaultCapacity ).
        this-object:Position        =   1. 
        DefaultCapacity = piDefaultCapacity.
    end constructor.
    
    /** Constructor for a ByteBucket
        
        @param integer The initial size of the bucket (ie how many 32k rows) 
        @deprecated(since='12.0':u). 
        */
    constructor public ByteBucket(input piInitialSize as integer):
        Assert:IsPositive(piInitialSize, 'Initial size').
        memoutStream = New Progress.io.MemoryOutputStream().
        this-object:Position        =   1.
    end constructor.
    
    /** Factory method for creating a ByteBucket.
    
        @param integer  The initial size of the array (ie how many extents)
        @param int64 The size of each memptr in the array */
    method public static ByteBucket Instance(input piInitialSize as integer, input piDefaultCapacity as int64):
        define variable oBB as ByteBucket no-undo.
        assign oBB = new ByteBucket(piInitialSize, piDefaultCapacity).
        oBB:Initialize().
        return oBB. 
    end method.

    /** Factory method for creating a ByteBucket.
    
        @param int64 The size of  memptr to store bytes */
    method public static ByteBucket Instance(input piDefaultCapacity as int64):
        define variable oBB as ByteBucket no-undo.
        
        assign oBB = new ByteBucket(piDefaultCapacity).
        oBB:Initialize().
        
        return oBB. 
    end method.
    
    /** Factory method for creating a ByteBucket. */
    method public static ByteBucket Instance():
        define variable oBB as ByteBucket no-undo.
        
        assign oBB = new ByteBucket().
        oBB:Initialize().
        
        return oBB. 
    end method.
    
    
    /** Clears/resets the ByteBucket. Does not de-allocate the memory, just the
        various pointers/counters/cursors. */
    method public void Clear():
         memoutStream:Clear().
         assign this-object:Position = 1.
             
        if get-size(mmTempBytes) gt 0 then
            set-size(mmTempBytes) = 0.
    end method.
    
    /** Default object initialization
        
        Clears and resizes the bucket's internals to the initial size (num records) */
    method public void Initialize():
        this-object:Clear().
    end method.
    
    /** Destroy/Shutdown/Anti-Initializer */
    method public void Destroy():
        assign this-object:Position = 1.
            
        delete object memoutStream.
        
        if get-size(mmTempBytes) gt 0 then
            set-size(mmTempBytes) = 0.
    end method.
    
    /** Resizes the internal 'array' of records.
        We can shrink down the number of rows, but not smaller than the 
        bucket's size. 
        
        @param integer The new size (number of extents) for the array */
    {&_proparse_ prolint-nowarn(varusage)}
    method public void ResizeArray(input piSize as integer):
        //this-object:Resize(piSize).    
    end method.
    
    /** Resizes the internal 'array' of records.
        We can shrink down the number of rows, but not smaller than the 
        bucket's size in bytes. 
        
        @param integer The new size (number of records) for the internal structure */
    {&_proparse_ prolint-nowarn(varusage)}    
    method public void Resize(input piSize as integer):        
    end method.
    
    /** Copies all of the bytes from a memptr into this bucket. The
        caller is responsible for cleaning up the memptr.
    
        @param int64 The pointer to memory represented by a memptr (via get-pointer-value). 
        @param int64 The size of the memptr represented by the pointer value. */
    method public void PutBytes(input piPointerValue as int64,
                                input piSize as int64):
        // Nothing to do if there's no data
        if piSize eq 0 then
            return.
        
        Assert:IsPositive(piPointerValue, 'Pointer Value').
        Assert:IsPositive(piSize, 'Memptr Size').
        
        /* jiggery-pokery so we can reuse code without deep-copying memptr's all over the show */
        set-size(mmTempBytes) = 1. /* allocate a new 1-byte memptr */
        set-size(mmTempBytes) = 0. /* free this 1-byte memptr, which also clears the size */
        set-pointer-value(mmTempBytes) = piPointerValue.
        set-size(mmTempBytes) = piSize.
         
        /* Start at the first byte of the input memptr */
        WriteBytes(1, piSize).
        
        finally:
            /* First de-reference the mmTempBytes variable before
               calling SET-SIZE() = 0 on it. */
            set-pointer-value(mmTempBytes) = 0.
            if get-size(mmTempBytes) gt 0 then
                set-size(mmTempBytes) = 0.
        end finally.
    end method.
    
    /** Copies all of the bytes from a String object (longchar) into this bucket. 
        
        @param String The longchar containing the source data. */
    method public void PutString(input poData as String):
        Assert:NotNull(poData, 'String data').
        
        PutString(poData:Value, poData:Encoding).
    end method.
    
    /** Copies all of the bytes from a longchar into this bucket. 
        
        @param longchar The longchar containing the source data */
    method public void PutString(input pcData as longchar):
        PutString(pcData, 'utf-8':u).
    end method.
    
    /** Copies all of the bytes from a longchar into this bucket.
        
        @param longchar The longchar containing the source data 
        @param longchar The target codepage used to write data into the bucket. Defaults to UTF-8 */
    @deprecated(since="11.7.3", use="PutString(longchar,character)").
    method public void PutString(input pcData as longchar,
                                 input pcTargetCodepage as longchar):
        PutString(pcData, string(pcTargetCodepage)).
    end method.
    
    /** Copies all of the bytes from a longchar into this bucket.
        
        @param longchar The longchar containing the source data
        @param character The target codepage used to write data into the bucket. Defaults to UTF-8 */
    method public void PutString(input pcData as longchar,
                                 input pcTargetCodepage as character):
        define variable mData as memptr no-undo.
        
        // Nothing to do if there's no data
        if length(pcData, 'raw':u) eq 0 then
            return.
        
        if    pcTargetCodepage eq '':u
           or pcTargetCodepage eq ? 
        then
            assign pcTargetCodepage = 'UTF-8':u.
        
        copy-lob pcData to mData
                 // the source codepage is taken from the longchar itself
                 convert target codepage pcTargetCodepage.
        
        PutBytes(get-pointer-value(mData), get-size(mData)).
        
        finally:
            if get-size(mData) gt 0 then
                set-size(mData) = 0.
        end finally.
    end method.
    
    /** Copies all of the bytes from a Memptr instance into this bucket. The
        caller is responsible for cleaning up the memptr.
    
        @param OpenEdge.Core.Memptr The Memptr instance containing the data. */
    method public void PutBytes(input poData as class Memptr):
        Assert:NotNull(poData, 'Data').
        if poData:Size gt 0 then
            PutBytes(poData:GetPointerValue(), poData:Size).
    end method.

    /** Copies all of the bytes from a ByteBucket instance into this bucket. The
        caller is responsible for cleaning up the source ByteBucket.
            
        @param ByteBucket The ByteBucket instance containing the data. */
    method public void PutBytes(input poData as class ByteBucket):
        Assert:NotNull(poData, 'Input data').
        // Nothing to do if there's no data
        if poData:Size eq 0 then
            return.
        
          memoutStream:write(poData:memoutStream:Data,1,poData:memoutStream:BytesWritten).
    end method.
    
    /** Copies all of the bytes from a memptr (primitive) into this bucket. The
        caller is responsible for cleaning up the memptr. 
    
        @param memptr The memptr containing the data. */
    method public void PutBytes(input pmData as memptr):
        // Nothing to do if there's no data
        if get-size(pmData) eq 0 then
            return.
        
        /* jiggery-pokery so we can reuse code without deep-copying memptr's all over the show */
        PutBytes(get-pointer-value(pmData), get-size(pmData)). 
    end method.
    
    /** Writes the contents/bytes of the currently-read memptr (mmTempBytes) 
        into this bucket. This method writes bytes until the current bucket is
        full, then resizes the bucket appropriately and calls itself. 
        
        @param int64 The start position in the memptr.
        @param int64 The number of bytes to write */
    method private void WriteBytes(input piStartPos as int64, 
                                   input piBytesLeft as int64):
       define var bwritten as int64 no-undo.
       
       assign bwritten             = memoutStream:write(mmTempBytes, piStartPos,piBytesLeft)
              this-object:Position = this-object:Position + bwritten
              .
    end method.
    
    /** Returns a byte at the current position , and increments the
        position marker.
        
        @return integer The byte value at the current position */
    method public integer GetByte():
        define variable iByte as integer no-undo.
        
        assign iByte                = GetByte(this-object:Position)
               this-object:Position = this-object:Position + 1. 
        return iByte.
    end method.
    
    /** Returns a byte at the specified position, and increments the
        position marker.
        
        @param int64 The position at which to return the byte.
        @return integer The byte value at the current position */
    
    method public integer GetByte(input piStartPos as int64):
        
        if piStartPos  <=  memoutStream:BytesWritten then do:
            return get-byte(memoutStream:Data,piStartPos).
        end.
        
        return 0.
        
    end method.
    
    /** Returns a string/character representation a particular number of bytes,
        from a given start position.
    
        @param int64 The start potision
        @param int64 The size of the data (in bytes) to return 
        @return longchar The character/string data requested     */
    method public longchar GetString(input piStartPos as int64,
                                     input piSliceSize as int64):
        return GetString(piStartPos, piSliceSize, session:cpinternal, 'UTF-8':u).         
    end method.

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
        define variable rawData as memptr no-undo.
        define variable stringData as longchar no-undo.
        
        Assert:IsPositive(piStartPos, 'Start position').
        Assert:IsZeroOrPositive(piSliceSize, 'Slice size').
        
        if    pcTargetCodepage eq '':u
           or pcTargetCodepage eq ? then
            assign pcTargetCodepage = 'utf-8':u.
        
        fix-codepage(stringData) = pcTargetCodepage.
        
        if    this-object:Size eq 0 
           or piSliceSize eq 0 then
            return stringData.
        
        if    pcSourceCodepage eq '':u
           or pcSourceCodepage eq ? then
            assign pcSourceCodepage = 'utf-8':u.
        
        set-size(rawData) = piSliceSize.
        
        ReadBytes(piStartPos, rawData).
        
        copy-lob from rawData to stringData
                 convert source codepage pcSourceCodepage
                         target codepage pcTargetCodepage.
        
        return stringData.
        finally:
            if get-size(rawData) gt 0 then
                set-size(rawData) = 0.
        end finally.
    end method.

    /** Returns a string/character representation a particular number of bytes,
        from the current Position.
    
        @param int64 The size of the data (in bytes) to return 
        @return longchar The character/string data requested     */
    method public longchar GetString(input piSliceSize as int64):
        return GetString(this-object:Position, piSliceSize).
    end method.
    
    /** Returns a string/character representation of the entire set of bytes.
        
        @return longchar The character/string data requested     */
    method public longchar GetString():
        return GetString(1, this-object:Size).
    end method.
    
    /** Returns the entire contents of this bucket as a Memptr instance.
    
        @return Memptr The complete bucket data */
    method public class Memptr GetBytes():
        return GetBytes(1, this-object:Size).
    end method.
    
    /** Returns a Memptr instance containing the specified number of bytes,
        starting at the current Position.
    
        @param int64 The number of bytes to return
        @return Memptr The complete bucket data */
    method public class Memptr GetBytes(input piSliceSize as int64):
        return GetBytes(this-object:Position, piSliceSize).
    end method.
    
    /** Returns a Memptr instance containing the specified number of bytes,
        starting at the specified postition.
    
        @param int64 The starting position
        @param int64 The number of bytes to return
        @return Memptr The complete bucket data */
    method public class Memptr GetBytes(input piStartPos as int64,
                                        input piSliceSize as int64):
        define variable data as memptr no-undo.
        
        /* return an empty Memptr */
        if    this-object:Size eq 0 
           or piSliceSize eq 0 
        then
            return Memptr:Empty.
        
        set-size(data) = piSliceSize.
        
        ReadBytes(piStartPos, data).
        
        return new Memptr(data).
        
        finally:
            if get-size(data) gt 0 then
                set-size(data) = 0.
        end finally.
    end method.
    
    /* Reads data from the internal TT records into a memptr
       for return by GetBytes() and GetString() and friends.
       
       - The caller is responsible for cleaning up the memptr.
       - The memptr size is also the number of bytes to read  
       
       @param int64  The start position to read
       @param memptr The memptr into which to read the data */
    method private void ReadBytes(input piStartPos as int64,
                                  input pData as memptr):
        
        define variable iBytesLeft as integer no-undo.
        define variable bytestoread as int64 no-undo.
        define variable mTemp as memptr no-undo.
        
        Assert:IsPositive(piStartPos, 'Start position').                         
        
        assign iBytesLeft   = get-size(pData). 
        bytestoread = iBytesLeft.
            
        if bytestoread gt memoutStream:BytesWritten then
            assign bytestoread = memoutStream:BytesWritten.
        
        // workaround for PSC00295004
        set-size(mTemp) = bytestoread.
        mTemp = get-bytes(memoutStream:Data,piStartPos,bytestoread).
        put-bytes(pData,1) = mTemp. 
        finally:
            if get-size(mTemp) gt 0 then
                set-size(mTemp) = 0.
        end finally.
    end method.
    
    /* Debug method to dump out current RAW bytes into numbered files 
       Files are named bytebucket-memptr-<number>.bin */
    method public void Debug():
        copy-lob from memoutStream:Data to file session:temp-dir + 'bytebucket-memptr-':u + string(int64(this-object)) + '.bin':u.         
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
        
        /* hash of all the bytes */
        return GetBytes():GetHash(poAlgorithm). 
    end method.
    
end class.