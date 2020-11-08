/* *************************************************************************************************************************
Copyright (c) 2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MemptrInputStream
    Description : An InputStream implementation that holds data in-memory.
    Author(s)   : pjudge
    Created     : 2019-03-27
    Notes       : * This should be replaced in 12.0.0+ with the Progress.IO.MemoryInputStream, for performance reasons
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Memptr.
using Progress.IO.InputStream.
using OpenEdge.Core.StringConstant.

class OpenEdge.Core.MemptrInputStream inherits InputStream:
    /* The current/last-read byte in the stream */
    define public property Position as int64 no-undo
        get.
        private set.
    
    /* The JSON data that is created from this data target */
    define public property Data as memptr no-undo
        get.
        private set.
    
    /* Default constructor */
    constructor public MemptrInputStream():
        assign this-object:Position = 1.
    end constructor.
    
    constructor public MemptrInputStream(input pData as class Memptr):
        this-object().
        
        Assert:NotNull(pData, 'Stream data').
        assign this-object:Data = pData:Value.
    end constructor.
    
    constructor public MemptrInputStream(input pData as memptr):
        this-object().
        
        assign this-object:Data = pData.
    end constructor.
    
    /** ABSTRACT INT64 Read(INPUT pmData AS MEMPTR,  INPUT offset AS INT64, INPUT len AS INT64).
        Description:
            When overridden in a derived class, reads ‘len’ bytes of data from the current input 
            stream into a specified MEMPTR variable starting at offset ‘offset’ and returns number 
            of bytes read.  */
    method override public int64 Read(input pTarget as memptr,
                                      input pOffset as int64,
                                      input pLength as int64):
        define variable bytesRead as int64 no-undo.
        
        assign bytesRead = get-size(pTarget)
               bytesRead = min(bytesRead, get-size(data), pLength)
               pOffset   = max(pOffset, 1)
               .
        if bytesRead eq 0 then
            return bytesRead.
        
        put-bytes(pTarget, pOffset) = get-bytes(data, this-object:Position, bytesRead).
        
        // move the cursor along
        SkipBytes(bytesRead).
        
        return bytesRead.
    end method.
    
    method override public int64 Read(input  pDelim as character,
                                      output pTarget as longchar):
        define variable delimByte as integer no-undo.
        define variable curByte as integer no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable bytesRead as int64 no-undo.
        
        // holds the mostest
        fix-codepage(pTarget) = 'utf-8':u.
        
        assign delimByte = asc(substring(pDelim, 1, 1)).
        if    delimByte eq 0 
           or delimByte eq ?
        then
            assign delimByte = asc(StringConstant:SPACE).
        
        assign cnt = get-size(Data).
        do loop = this-object:Position to cnt:
            assign curByte = get-byte(data, loop).
            if curByte eq delimByte then
                leave.  
            assign pTarget   = pTarget + chr(curByte, 'utf-8':u)
                   bytesRead = bytesRead + 1
                   .
        end.
        
        // move the cursor along; +1 for the delimiter
        SkipBytes(bytesRead + 1).
        
        return bytesRead.
    end method.
    
    method override public int64 Read(input pDelim as character,
                                      output pTarget as character):
        define variable targetValue as longchar no-undo.
        define variable bytesRead as int64 no-undo.
        
        Read(pDelim, output targetValue).
        
        assign pTarget   = codepage-convert(string(targetValue))
               bytesRead = length(pTarget, 'raw':u)
               .
        return bytesRead.
    end method.
    
    /* Skips over and discards n btyes from the current input stream. 
       
       @param int64 The number of bytes to skip. + skips forward (toward Data:Size); - skips toward 1.
       @return int64 Returns number of bytes skipped. Returns 0, if we already at the end of the stream. */
    method override public int64 SkipBytes(input pSkip as int64):
        define variable skipBytes as int64 no-undo initial 0.
        define variable dataSize as int64 no-undo.
        
        assign dataSize = get-size(Data).
         
        if    this-object:Position ge dataSize
           or pSkip eq 0
        then
            return skipBytes.
        
        Assert:NotNull(pSkip, 'Skip bytes').
        
        if pSkip gt 0 then
            assign skipBytes            = min(dataSize, this-object:Position + pSkip - 1)
                   this-object:Position = this-object:Position + skipBytes
                   .
        else
            assign skipBytes            = abs(pSkip)   // easier doing maths with positive numbers 
                   skipBytes            = min(skipBytes, this-object:Position)
                   this-object:Position = this-object:Position - skipBytes
                   .
        return skipBytes.
    end method.
    
    method override public void Close():
        super:Close().
        
        assign this-object:Position = 1. 
    end method.

end class.