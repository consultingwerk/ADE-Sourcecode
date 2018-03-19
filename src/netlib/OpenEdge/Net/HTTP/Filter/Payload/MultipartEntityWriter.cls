/************************************************
Copyright (c) 2015, 2017 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MultipartEntityWriter
    Purpose     : Creates a MultiPartEntity per http://tools.ietf.org/html/rfc2046
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jul 01 16:53:21 EDT 2015
    Notes       : - Write() operations are destructive (they replace the existing
                    Entity).    
                  - http://www.w3.org/Protocols/rfc1341/7_2_Multipart.html
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.ISupportMultipartEntity.
using OpenEdge.Net.MessagePart.
using OpenEdge.Net.MultipartEntity.
using Progress.Lang.AppError.
using Progress.Lang.Object.
using OpenEdge.Core.StringConstant.

class OpenEdge.Net.HTTP.Filter.Payload.MultipartEntityWriter inherits MessageWriter
        implements ISupportMultipartEntity: 
    
    /** The character string delimiting the parts. Excludes the leading and trailing -- */
    define public property Boundary as character no-undo get. set.
    
    constructor public MultipartEntityWriter():
        super (get-class(MultipartEntity)).
    end constructor.

    method override public int64 Write(input poData as Object):
        define variable oBody as class Memptr no-undo.
        
        Assert:NotNull(poData).
        
        if type-of(poData, Memptr) then
            assign oBody = cast(poData, Memptr).
        else
        if type-of(poData, ByteBucket) then
            assign oBody = cast(poData, ByteBucket):GetBytes().
        else        
            return error new AppError(
                            substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                            , 0).
        
        return this-object:Write(oBody:Value).
    end method.

    method override public int64 Write(input pmData as memptr):
        define variable oMPE as MultipartEntity no-undo.
        define variable oPart as MessagePart no-undo.
        define variable iLoop as int64 no-undo.
        define variable iSize as int64 no-undo.
        define variable iByte as integer no-undo.
        define variable iPrevByte as integer no-undo.
        define variable iPartNum as integer no-undo.
        define variable iStartPos as int64 no-undo.
        define variable iEndPos as int64 no-undo.
        define variable iPartLoop as int64 no-undo.
        define variable iNumBytes as int64 no-undo.
        define variable cHeader as character no-undo.
        define variable cPotentialBoundary as character no-undo.
        define variable oPartWriter as MessageWriter no-undo.
        define variable iBoundaryLength as integer no-undo.
        define variable mPartData as memptr no-undo.
        define variable iPos as integer no-undo.
        define variable cName as character no-undo.
        define variable cValue as character no-undo.
        define variable lHeadersRead as logical no-undo.
        define variable oPartData as ByteBucket no-undo.
        define variable iStartDataPos as int64 no-undo.
        
        assign iSize = get-size(pmData).
        
        Assert:IsZeroOrPositive(iSize, 'Data size').
        
        assign oMPE               = new MultipartEntity()
               oMPE:Boundary      = this-object:Boundary
               this-object:Entity = oMPE
               iBoundaryLength    = length(this-object:Boundary, 'raw':u)
               /* postition of first byte of part, excluding boundaries */
               iStartPos          = 1
               iPartNum           = 0
               lHeadersRead       = false
               oPartData          = ByteBucket:Instance().
               
        _Debug(pmData).
                   
        MAIN-LOOP:
        do iLoop = 1 to iSize:
            assign iByte = get-byte(pmData, iLoop).
            
               /* double hyphen/dash -- or end-of-data */
            if (iByte eq 45 and iPrevByte eq 45) or
               (iLoop eq iSize) then
            do:
                assign cPotentialBoundary = get-string(pmData, iLoop + 1, iBoundaryLength).
                if cPotentialBoundary eq this-object:Boundary then
                do:
                    /* postition of last byte of part, excluding boundaries */                                             
                    assign iEndPos           = (iLoop - 2 /* for the -- */ - 2 /* for CRLF */)
                           lHeadersRead      = false
                           oPartWriter       = ?
                           iNumBytes         = 0.
                    
                    /* everything before this point is a part or prologue.
                       if we're on the 2nd byte, then there's no prologue. */
                    case iPartNum:
                        when 0 then
                            assign oMPE:Prologue = get-string(pmData, iStartPos, max(0, iEndPos - iStartPos + 1)).
                        otherwise 
                        do:
                            assign oPart     = new MessagePart()
                                   iPrevByte = 0.  /* reset */
                            
                            PART-LOOP:
                            do iPartLoop = iStartPos to iEndPos:
                                assign iByte     = get-byte(pmData, iPartLoop)
                                       iNumBytes = iNumBytes + 1
                                       .
                                if not lHeadersRead then
                                do:
                                    /* don't count the CR/LF as bytes */
                                    if iByte eq 13 or iByte eq 10 then
                                        assign iNumBytes = iNumBytes - 1.
                                    
                                    /* if we're at the end of our chunk of data, or we have hit 
                                       the carriage return */
                                    if ( (iPrevByte eq 13 /*CR*/ and iByte eq 10 /*LF*/ ) or 
                                         iPartLoop eq iEndPos) and
                                       iNumBytes gt 0 then
                                    do:
                                        /* start at the beginning of this word/token. */
                                        assign cHeader = get-string(pmData, iPartLoop - (iNumBytes + 1), iNumBytes)
                                               iPos    = index(cHeader, ':':u)
                                               cName   = substring(cHeader, 1, iPos - 1)
                                               cValue  = left-trim(substring(cHeader, iPos + 1))
                                               .
                                        oPart:Headers:Put(HttpHeaderBuilder:Build(cName):Value(cValue):Header).                                               
                                               /* reset counters/temps */
                                        assign cHeader = '':u
                                               iNumBytes = 0.
                                    end.
                                    
                                    /* if this is the 2nd CRLF then we have finished all the headers 
                                    
                                       NOTE: usually we check for line ending by having CR+LF. Here we
                                       check for LF then CR since that means the first byte following a
                                       LF is another line ending (CR). */
                                    if iByte eq 10 and iNumBytes eq 0 and 
                                       get-string(pmData, iPartLoop - 3 /* 1-based counting */, 4) eq (StringConstant:CRLF + StringConstant:CRLF) then
                                        assign lHeadersRead  = true
                                               iStartDataPos = iPartLoop.
                                                                                                               
                                end. /* headers not yet read */
                                else
                                if lHeadersRead then
                                do on error undo, throw:
                                    assign mPartData   = get-bytes(pmData, iStartDataPos + 1, iEndPos - iStartDataPos)                                        
                                           oPartWriter = EntityWriterBuilder:Build(oPart)
                                                            :Writer.
                                    Assert:NotNull(oPartWriter, 'Part writer').
                                    
                                    oPartData:PutBytes(get-pointer-value(mPartData), 
                                                       get-size (mPartData)).
                                    
                                    /* create the entity */
                                    oPartWriter:Open().
                                    oPartWriter:Write(oPartData).
                                    oPartWriter:Close().
                                    
                                    assign oPart:Body = oPartWriter:Entity.
                                    
                                    /* Only add the part to the entity once done, with success. */
                                    oMPE:AddPart(oPart).
                                    
                                    leave PART-LOOP.
                                    finally:
                                        set-size(mPartData) = 0.
                                        oPartData:Clear().
                                    end finally.
                                end.    /* now read the data! */
                                
                                assign iPrevByte = iByte.
                            end.    /* PART-LOOP: */
                        end.    /* otherwise ... */
                    end case. /* partnum */
                    
                    assign iStartPos = iLoop + 1 + iBoundaryLength.
                    
                    /* if this is the last boundary, mark it as such */                            
                    if get-string(pmData, iStartPos, 2) eq '--':u then
                    do:
                        if iSize ge (iStartPos + 4) then
                            assign oMPE:Epilogue = get-string(pmData, iStartPos + 4 /* CRLF-- */).
                        
                        /* so we leave processing */
                        assign iLoop = iSize.

                        if oMPE:Epilogue eq StringConstant:CRLF then
                            assign oMPE:Epilogue = '':u. 
                                                       
                        leave MAIN-LOOP.
                    end.
                    else
                        assign iPartNum = iPartNum + 1.
                    
                    assign iStartPos = iStartPos + 2 /* CRLF */
                           iLoop     = iStartPos - 1 /* AVM will add 1 on the next iteration of this loop*/
                           iByte     = get-byte(pmData, iLoop)
                           .
                end. /* we're at a boundary */
            end.    /* MAIN-LOOP: */
            
            assign iPrevByte = iByte.
        end.
        
        return iSize.
    end method.

    method private void _Debug(input mmValue as memptr):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iByte as integer no-undo.
        define variable cDumpFile as character no-undo.
        
        if not log-manager:logging-level gt 4 then
            return.
        
        assign iMax = get-size(mmValue)
               cDumpFile = session:temp-directory + 'mpe-'+ string(integer(this-object)) + '.txt':u.
        
        if log-manager:logfile-name ne ? then
            log-manager:write-message('DEBUG FILE=':u + cDumpFile, 'MPARTENT':u).
        
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
