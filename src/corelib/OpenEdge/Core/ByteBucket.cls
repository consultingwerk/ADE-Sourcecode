/************************************************
Copyright (c)  2014-2016 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ByteBucket
    Purpose     : An extensible bucket/container for byte-based data. The bucket
                  consists of an array of Memptr objects, all set to a particular
                  size. 
    Author(s)   : pjudge
    Created     : Wed May 14 16:26:38 EDT 2014
    Notes       : * Bucket size is initially 3 x 16k memptrs, and will expand
                    to contain whatever's passed in.
                  * ResizeArray() can be used to manually expand the size of the 
                    bucket
                  * The memptr default size can be specified on construction.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.Util.MathUtil.
using OpenEdge.Core.String.
using OpenEdge.Core.Assert.
using OpenEdge.Core.HashAlgorithmEnum.
using OpenEdge.Core.ISupportInitialize.

class OpenEdge.Core.ByteBucket implements ISupportInitialize:
    /** The backing collection of memptrs */
    define private variable mmMemptrArray as memptr extent no-undo.
    
    /* Number of Memptrs under management here */    
    define private variable miArraySize         as integer no-undo.
    
    /* the current position in the memptr */
    define private variable miMemptrPostion as int64 extent no-undo.
    
    /** The current read position */
    define public property Position as int64 no-undo get. set.
    
    define private variable miCurrentArrayIndex as integer no-undo.
    
    /* global/stateful variable to avoid deep copies of memptrs being passed internally/this class */
    define private variable mmTempBytes as memptr no-undo.
     
    /** The initial size of the memptrs that are held in the Bucket's array. 
        Each memptr is the same size */
    define public property DefaultCapacity as int64 no-undo get. private set.
    
    /** Returns the size of the data in the bucket */    
    define public property Size as int64 no-undo get. private set.
    
    /** Constructor for a ByteBucket. Defaults to 2 memptrs of 16k each */
    constructor public ByteBucket():
        /* initialise to 3 16k memptrs */
        this-object(3, 0x4000 /* 16kb */).
    end method.
    
    /** Constructor for a ByteBucket
        @param int64 The size of each memptr in the array */
    constructor public ByteBucket(input piDefaultCapacity as int64):
        this-object(3, piDefaultCapacity).
    end constructor.
    
    destructor ByteBucket():
        Destroy().
    end destructor.
    
    /** Constructor for a ByteBucket
        @param integer  The initial size of the array (ie how many extents)
        @param int64 The size of each memptr in the array */
    constructor public ByteBucket(input piInitialSize as integer, input piDefaultCapacity as int64):
        Assert:IsPositive(piInitialSize, 'Initial size').
        Assert:IsPositive(piDefaultCapacity, 'Initial capacity').
        
        assign 
            extent(mmMemptrArray)    = piInitialSize
            miArraySize              = piInitialSize
            extent(miMemptrPostion)  = miArraySize
            miMemptrPostion          = 1
            miCurrentArrayIndex      = 1
            
            this-object:Position     = 1
            this-object:DefaultCapacity = piDefaultCapacity
            .
    end constructor.
    
    /** Factory method for creating a ByteBucket.
    
        @param integer  The initial size of the array (ie how many extents)
        @param int64 The size of each memptr in the array */
    method public static ByteBucket Instance(input piInitialSize as integer, input piDefaultCapacity as int64):
        define variable oBB as ByteBucket no-undo.
        
        oBB = new ByteBucket(piInitialSize, piDefaultCapacity).
        oBB:Initialize().
        
        return oBB. 
    end method.

    /** Factory method for creating a ByteBucket.
    
        @param int64 The size of each memptr in the array */
    method public static ByteBucket Instance(input piDefaultCapacity as int64):
        define variable oBB as ByteBucket no-undo.
        
        oBB = new ByteBucket(piDefaultCapacity).
        oBB:Initialize().
        
        return oBB. 
    end method.
    
    /** Factory method for creating a ByteBucket. */
    method public static ByteBucket Instance():
        define variable oBB as ByteBucket no-undo.
        
        oBB = new ByteBucket().
        oBB:Initialize().
        
        return oBB. 
    end method.
    
    /** Clears/resets the ByteBucket. Does not de-allocate the memory, just the
        various pointers/counters/cursors. */
    method public void Clear():
        assign miMemptrPostion      = 1
               this-object:Position = 1
               this-object:Size     = 0
               miCurrentArrayIndex  = 1.
        set-size(mmTempBytes) = 0.
    end method.
    
    /** Default object initialization */
    method public void Initialize():
        define variable iLoop as integer no-undo.
        
        this-object:Clear().
        
        do iLoop = 1 to miArraySize:
            set-size(mmMemptrArray[iLoop]) = 0.
            set-size(mmMemptrArray[iLoop]) = this-object:DefaultCapacity.
        end.
    end method.
    
    /** Destroy/Shutdown/Anti-Initializer */
    method public void Destroy():
        define variable iLoop as integer no-undo.
        
        do iLoop = 1 to miArraySize:
            set-size(mmMemptrArray[iLoop]) = 0.
        end.
        
        set-size(mmTempBytes) = 0.
    end method.
    
    /** Resizes the internal array. Note that arrays can only be enlarged.
        
        @param integer The new size (number of extents) for the array */
    method public void ResizeArray(input piSize as integer):
        define variable mTempArray as memptr extent no-undo.
        define variable iTempPosition as integer extent no-undo.
        define variable iLoop as integer no-undo.
        
        Assert:IsZeroOrPositive(piSize - miArraySize, 'Difference between new and old size').
        
        /* no-op */
        if piSize - extent(mmMemptrArray) eq 0 then
            return.                       
        
        assign mTempArray    = mmMemptrArray
               iTempPosition = miMemptrPostion.
        
        /* clean out the memptrs */       
        do iLoop = 1 to miArraySize:
            set-size(mmMemptrArray[iLoop]) = 0.
        end.
        
        assign extent(mmMemptrArray) = ?
               extent(mmMemptrArray) = piSize
               
               extent(miMemptrPostion) = ?
               extent(miMemptrPostion) = piSize
               
               miMemptrPostion = 1.
        
        do iLoop = 1 to piSize:
            if iLoop le miArraySize then
            do:
                assign mmMemptrArray[iLoop]   = mTempArray[iLoop]
                       miMemptrPostion[iLoop] = iTempPosition[iLoop].
                set-size(mTempArray[iLoop]) = 0.
            end.
            else
                set-size(mmMemptrArray[iLoop]) =  this-object:DefaultCapacity.
                /* position done above */
        end.
        assign miArraySize = piSize.
    end method.
    
    /** Copies all of the bytes from a memptr into this bucket. The
        caller is responsible for cleaning up the memptr.
    
        @param int64 The pointer to memory represented by a memptr (via get-pointer-value). 
        @param int64 The size of the memptr represented by the pointer value. */
    method public void PutBytes(input piPointerValue as int64,
                                input piSize as int64):
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
            set-size(mmTempBytes) = 0.           
        end finally.
    end method.
    
    /** Copies all of the bytes from a String object (longchar) into this bucket. 
   
        @param String The longchar containing the source data. */
    method public void PutString(input poData as String):
        define variable mData as memptr no-undo.
        
        set-size(mData) = poData:Size + 1.
        put-string(mData,1) = poData:Value.
        
        /* don't write the trailing null byte */
        PutBytes(get-pointer-value(mData), get-size(mData) - 1).
        
        finally:
            set-size(mData) = 0.
        end finally.
    end method.
    
    /** Copies all of the bytes from a longchar into this bucket. 
   
        @param longchar The longchar containing the source data */
    method public void PutString(input pcData as longchar):
        define variable mData as memptr no-undo.
        
        set-size(mData) = length(pcData, 'RAW') + 1.
        put-string(mData,1) = pcData.
        
        /* don't write the trailing null byte */
        PutBytes(get-pointer-value(mData), get-size(mData) - 1).
        
        finally:
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
        /* We use a static method because it gives us access to the private/
           internal members of both instances. We want to do this merge as 
           quickly as possible  */
        ByteBucket:MergeBuckets(poData, this-object).
    end method.
    
    /** Merges the contents of 2 ByteBuckets
    
        @param ByteBucket The source bucket (ie where we are copying FROM ) 
        @param ByteBucket The target bucket (ie where we are copying TO) */
    method static private void MergeBuckets (input poSource as ByteBucket,
                                             input poTarget as ByteBucket):
        define variable iLoop as integer no-undo.
        define variable iNumBytes as integer no-undo.
        define variable iPutAt as integer no-undo.
        define variable iStartIndex as integer no-undo.
        define variable iBytesLeft as integer no-undo.
        define variable iStartPos as integer no-undo.
        
        assign iBytesLeft   = poSource:Size               
               iPutAt       = 1
               iStartPos    = 1
               iStartIndex  = 1.
        
        do iLoop = iStartIndex to poSource:miCurrentArrayIndex 
                while iBytesLeft gt 0
                on error undo, throw:
            /* read the number of bytes. if we need to read the whole
               memptr, then do so. otherwise just the number of remaining
               bytes. */
            assign iNumBytes  = min(get-size(poSource:mmMemptrArray[iLoop]), iBytesLeft)
                   iBytesLeft = iBytesLeft - iNumBytes.
            
            /* jiggery-pokery so we can reuse code without deep-copying memptr's all over the show */
            set-size(poTarget:mmTempBytes) = 1.  /* allocate a new 1-byte memptr */
            set-size(poTarget:mmTempBytes) = 0.  /* free this 1-byte memptr, which also clears the size */
            set-pointer-value(poTarget:mmTempBytes) = get-pointer-value(poSource:mmMemptrArray[iLoop]).
            set-size(poTarget:mmTempBytes)          = get-size(poSource:mmMemptrArray[iLoop]).
            
            /* Start at the first byte of the input memptr */
            poTarget:WriteBytes(1, iNumBytes).
            
            finally:
                /* First de-reference the mmTempBytes variable before
                   calling SET-SIZE() = 0 on it. */
                set-pointer-value(poTarget:mmTempBytes) = 0.
                set-size(poTarget:mmTempBytes) = 0.
            end finally.
        end.
    end method.
    
    /** Copies all of the bytes from a memptr (primitive) into this bucket. The
        caller is responsible for cleaning up the memptr. 
    
        @param memptr The memptr containing the data. */
    method public void PutBytes(input pmData as memptr):
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
        define variable iArrayLoop as integer no-undo.
        define variable iNumBytes as integer no-undo.
        define variable iByteLoop as integer no-undo.
        define variable iMaxBytes as integer no-undo.
        
        Assert:IsPositive(piStartPos, 'Start position').
        Assert:IsPositive(piBytesLeft, 'Num bytes left').
        
        do iArrayLoop = miCurrentArrayIndex to miArraySize
                while piBytesLeft gt 0
                on error undo, throw:
            /* If this Memptr is full, go to next. Will typically happen when
               we've extended the Bucket's size */
            if get-size(mmMemptrArray[iArrayLoop]) eq miMemptrPostion[iArrayLoop] then
                next.
            
            assign iNumBytes = min(get-size(mmMemptrArray[iArrayLoop]) - miMemptrPostion[iArrayLoop] + 1, /* +1 'cos we're 1-based */ 
                                   piBytesLeft)
                   piBytesLeft = piBytesLeft - iNumBytes.
            
            /* Only write into this memptr if we have space to do so. */
            if iNumBytes gt 0 then
            do:
                put-bytes(mmMemptrArray[iArrayLoop], miMemptrPostion[iArrayLoop]) =
                    get-bytes(mmTempBytes, piStartPos, iNumBytes).
            
                /* Increment */
                assign piStartPos             = piStartPos + iNumBytes
                       miMemptrPostion[iArrayLoop] = min(miMemptrPostion[iArrayLoop] + iNumBytes, get-size(mmMemptrArray[iArrayLoop]))
                       this-object:Position   = this-object:Position + iNumBytes
                       this-object:Size       = this-object:Size + iNumBytes.
            end.
            finally:
                assign miCurrentArrayIndex = iArrayLoop.
            end finally.
        end.
        
        if piBytesLeft gt 0 then
        do:
            /* Add at least enough space for the remaining data */
            ResizeArray(miArraySize + int(piBytesLeft / DefaultCapacity) + 1 ).
            WriteBytes(piStartPos, piBytesLeft).
        end.
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
        define variable iStartIndex as integer no-undo.
        define variable iGetFrom as integer no-undo.
        
        Assert:IsPositive(piStartPos, 'Start position').
                
        assign iStartIndex  = MathUtil:Ceiling(piStartPos / DefaultCapacity)
               /* Figure out where to start in the array entry */               
               iGetFrom     = piStartPos modulo DefaultCapacity.
        
        /* if get from is 0 then piStartPos is a multiple of DefaultCapacity (ie the last
           byte of a particular array). */
        if iGetFrom eq 0 then
            assign iGetFrom = DefaultCapacity.
        
        return get-byte(mmMemptrArray[iStartIndex], iGetFrom).
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
        define variable lcData as longchar no-undo.
        define variable lcTemp as longchar no-undo.
        define variable iLoop as integer no-undo.
        define variable iNumBytes as integer no-undo.
        define variable iPutAt as integer no-undo.
        define variable iStartIndex as integer no-undo.
        define variable iGetFrom as integer no-undo.
        define variable iBytesLeft as integer no-undo.
        
        Assert:IsPositive(piStartPos, 'Start position').
        Assert:IsZeroOrPositive(piSliceSize, 'Slice size').
        Assert:NotNullOrEmpty(pcSourceCodepage, 'Source codepage').
        Assert:NotNullOrEmpty(pcTargetCodepage, 'Target codepage').
        
        fix-codepage(lcData) = pcTargetCodepage.
        
        /* return an empty Memptr */        
        if this-object:Size eq 0 then
            return lcData.
        
        assign iBytesLeft   = piSliceSize
               iPutAt       = 1
               
               iStartIndex  = MathUtil:Ceiling(piStartPos / DefaultCapacity).
               
               /* Figure out where to start in the array entry */               
               iGetFrom     = piStartPos modulo DefaultCapacity.
        
        /* if get from is 0 then piStartPos is a multiple of DefaultCapacity (ie the last
           byte of a particular array). */
        if iGetFrom eq 0 then
            assign iGetFrom = DefaultCapacity.
        
        fix-codepage(lcTemp) = pcTargetCodepage.
        do iLoop = iStartIndex to miCurrentArrayIndex 
                while iBytesLeft gt 0:
            
            /* read the number of bytes. if we need to read the whole
               memptr, then do so. otherwise just the number of remaining
               bytes. */
            if iGetFrom eq DefaultCapacity then
                iNumBytes = 1.
            else
                /* we may have a get-from value somewhere in the middle */
                iNumBytes = min(get-size(mmMemptrArray[iLoop]) - iGetFrom + 1, iBytesLeft).
            
            copy-lob from mmMemptrArray[iLoop] starting at iGetFrom for iNumBytes
                     to lcTemp
                     convert
                        source codepage pcSourceCodepage 
                        target codepage pcTargetCodepage.
            
            assign lcData      = lcData     + lcTemp
                   iPutAt      = iPutAt     + iNumBytes
                   iBytesLeft  = iBytesLeft - iNumBytes
                   /* start from the beginning of the next chunk */
                   iGetFrom    = 1.
        end.
            
        return lcData.
    end method.

    /** Returns a string/character representation a particular number of bytes,
        from the current Position.
    
        @param int64 The size of the data (in bytes) to return 
        @return longchar The character/string data requested     */
    method public longchar GetString(input piSliceSize as int64):
        return GetString(this-object:Position, piSliceSize).
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
        define variable mTemp as memptr no-undo.
        define variable iLoop as integer no-undo.
        define variable iNumBytes as integer no-undo.
        define variable iPutAt as integer no-undo.
        define variable iStartIndex as integer no-undo.
        define variable iGetFrom as integer no-undo.
        define variable iBytesLeft as integer no-undo.
        define variable mHolder as memptr no-undo.
                
        Assert:IsPositive(piStartPos, 'Start position').
        Assert:IsZeroOrPositive(piSliceSize, 'Slice size').
        
        /* return an empty Memptr */        
        if this-object:Size eq 0 then
            return new Memptr(0).
                
        set-size(mTemp) = piSliceSize.
                         
        assign iBytesLeft   = piSliceSize               
               iPutAt       = 1
               
               iStartIndex  = MathUtil:Ceiling(piStartPos / DefaultCapacity).
               
               /* Figure out where to start in the array entry */               
               iGetFrom     = piStartPos modulo DefaultCapacity.
        
        /* if get from is 0 then piStartPos is a multiple of DefaultCapacity (ie the last
           byte of a particular array). */
        if iGetFrom eq 0 then
            assign iGetFrom = DefaultCapacity.
        
        do iLoop = iStartIndex to miCurrentArrayIndex 
                while iBytesLeft gt 0:
            
            /* read the number of bytes. if we need to read the whole
               memptr, then do so. otherwise just the number of remaining
               bytes. */
            if iGetFrom eq DefaultCapacity then
                iNumBytes = 1.
            else
                /* we may have a get-from value somewhere in the middle */
                iNumBytes = min(get-size(mmMemptrArray[iLoop]) - iGetFrom + 1, iBytesLeft).
            
            put-bytes(mTemp, iPutAt) = 
                    get-bytes(mmMemptrArray[iLoop],
                                    iGetFrom,
                                    iNumBytes).
            
            assign iPutAt      = iPutAt     + iNumBytes
                   iBytesLeft  = iBytesLeft - iNumBytes
                   /* start from the beginning of the next chunk */
                   iGetFrom    = 1.
        end.
        
        return new Memptr(mTemp).
        finally:
            set-size(mTemp) = 0.
        end finally.
    end method.

    method public void Debug():
        define variable iLoop as integer no-undo.
        define variable mData as memptr no-undo.
        
        if log-manager:logging-level ge 5 then
        do iLoop = 1 to miArraySize:
            copy-lob from mmMemptrArray[iLoop] to file session:temp-dir + 'bytebucket-memptr-' + string(iLoop) + '.txt'.
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
        
        /* hash of all the bytes */
        return GetBytes():GetHash(poAlgorithm). 
    end method.
    
end class.