/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ClientSocketResponseWriter
    Purpose     : Writes HTTP data received from socket into a response and
                  a message body object (byte bucket) 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jan 26 09:57:31 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.Util.MathUtil.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using OpenEdge.Net.ServerConnection.SocketReadEventArgs.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.

class OpenEdge.Net.HTTP.Filter.Payload.ClientSocketResponseWriter
        implements IHttpMessageWriter, ISupportInitialize:
    
    /* transient variables used to keep parts-of-a-line that span responses */
    define private variable mlcCurrentLine as longchar no-undo.
    define private variable moChunk as ByteBucket no-undo.
    define private variable miChunkSize as integer no-undo.
    define private variable miChunkBytesRemaining as integer no-undo.
    define private variable mlStatusLineRead as logical no-undo.
    define private variable mlHeadersRead as logical no-undo.
    
    /* the message body, passed-in */
    define protected property MessageBody as ByteBucket no-undo get. private set.
    
    /* helper variable for the response, to avoid constant casting */
    define protected property Response as IHttpResponse no-undo get. private set.
    
    /** (mandatory) The message that's being written */  
    define public property Message as IHttpMessage no-undo
        get():
            return Response.
        end get.
    
    constructor public ClientSocketResponseWriter(input poMessage as IHttpResponse,
                                                  input poMessageBody as ByteBucket):
        Assert:NotNull(poMessage, 'Http Response').
        Assert:NotNull(poMessageBody, 'Message body').
        
        assign Response = poMessage
               this-object:MessageBody = poMessageBody
               moChunk = ByteBucket:Instance().
    end method.
    
    /* Initializer/Startup */
    method public void Initialize():
        assign mlStatusLineRead = false
               mlHeadersRead    = false
               mlcCurrentLine   = '':u
               miChunkSize      = ?
               .
        fix-codepage(mlcCurrentLine) = 'utf-8':u.
    end method.
    
    /* Destroy/Shutdown/Anti-Initializer */
    method public void Destroy():
        moChunk:Clear().
    end method.
    
    /**  Closes the output. See Open() */
    method public void Close():
        /* no-op */
    end method.

    /** Opens the writer for output. Open/Close allows us to write the same message multiple
        times without requiring a new writer each time. */
    method public void Open():
        this-object:MessageBody:Clear().
    end method.
    
    /** Write data to the output location 
        
        @param Object Data to write */
    method public void Write(input poData as Object):
        define variable iBytesRead as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable iByte as integer no-undo.
        define variable iStartByte as integer no-undo.
        define variable iPrevByte as integer no-undo.
        define variable iNumBytes as integer no-undo.
        define variable iChunkSize as integer no-undo.
        define variable iPos as integer no-undo.
        define variable oTempData as class Memptr no-undo.
        define variable cName as character no-undo.
        define variable cValue as character no-undo.
        define variable oSocketArgs as SocketReadEventArgs no-undo.
        
        Assert:IsType(poData, get-class(SocketReadEventArgs)).

        /* Parses a chunk of data that's received from the socket. May or not
            be a complete payload
            
            Per the HTTP 1.1 spec at http://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html#sec6,
            it has the following format.
            
            Response      = Status-Line               ; Section 6.1
                           *(( general-header        ; Section 4.5
                            | response-header        ; Section 6.2
                            | entity-header ) CRLF)  ; Section 7.1
                           CRLF
                           [ message-body ]          ; Section 7.2      */        
        assign oSocketArgs = cast(poData, SocketReadEventArgs)
               iBytesRead = oSocketArgs:BytesRead
               iStartByte = 1.
        
        /* first line is the status line */
        do while not mlStatusLineRead:
            /* we know that the first 14 character are a fixed format per the HTTP spec.
               
               Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF
                    SP = space
                    HTTP-Version   = "HTTP" "/" 1*DIGIT "." 1*DIGIT
                    Status-Code    = 3*DIGIT
                    Reason-Phrase  = *<TEXT, excluding CR, LF>
            */        
            do iLoop = iStartByte to iBytesRead while not mlStatusLineRead:
                assign iByte     = oSocketArgs:Data:GetByte(iLoop)
                       iNumBytes = iNumBytes + 1.
                /* don't count the CR/LF as bytes */
                if iByte eq 13 or iByte eq 10 then
                    assign iNumBytes = iNumBytes - 1.
                                       
                /* if we're at the end of our chunk of data, or we have hit 
                   the carriage return */
                if (iPrevByte eq 13 /*CR*/ and iByte eq 10 /*LF*/ ) or 
                   iLoop eq iBytesRead then
                    assign mlStatusLineRead = true
                           mlcCurrentLine   = mlcCurrentLine 
                                            + oSocketArgs:Data:GetString(iStartByte, iNumBytes)
                           iNumBytes = 0.
                assign iPrevByte = iByte.
            end. /* byte loop */
            
            assign iStartByte = iLoop.
            
            if mlStatusLineRead then
            do:
                /* assumption is that we're getting at least the status line in a chunk */
                assign cValue = substring(mlcCurrentLine, 1, 8).             
                Response:Version = cValue.
                
                Response:StatusCode = integer(substring(mlcCurrentLine, 10, 3)).
                assign cValue = substring(mlcCurrentLine, 14).
                Response:StatusReason = cValue.
                assign mlcCurrentLine = '':u
                       /* read the status line again? */
                       mlStatusLineRead = (not Response:StatusCode eq StatusCodeEnum:Continue:Value).
            end.
        end. /* do while not read */
        
        /* no else since we may have enough data to deal with all of this */
        /* followed by headers */
        if not mlHeadersRead then
        do:
            do iLoop = iStartByte to iBytesRead while not mlHeadersRead:
                assign iByte     = oSocketArgs:Data:GetByte(iLoop)
                       iNumBytes = iNumBytes + 1.
                
                /* don't count the CR/LF as bytes */
                if iByte eq 13 or iByte eq 10 then
                    assign iNumBytes = iNumBytes - 1.
                
                /* if we're at the end of our chunk of data, or we have hit 
                   the carriage return */
                if (iPrevByte eq 13 /*CR*/ and iByte eq 10 /*LF*/ ) or 
                   iLoop eq iBytesRead then
                assign mlcCurrentLine = mlcCurrentLine
                                      /* start at the beginning of this word/token. */
                                      + oSocketArgs:Data:GetString(iLoop - (iNumBytes + 1), iNumBytes).
                
                /* if we're at the end of the line, add the header to the response */
                if iByte eq 10 and iNumBytes gt 0 then
                do:
                    assign iPos   = index(mlcCurrentLine, ':':u)
                           cName  = substring(mlcCurrentLine, 1, iPos - 1)
                           cValue = left-trim(substring(mlcCurrentLine, iPos + 1))
                    /* reset counters/temps */
                           mlcCurrentLine = '':u
                           iNumBytes      = 0.
                    Response:SetHeader(
                        HttpHeaderBuilder:Build(cName):Value(cValue):Header).
                end.
                
                /* if this is the 2nd CRLF then we have finished all the headers 
                
                   NOTE: usually we check for line ending by having CR+LF. Here we
                   check for LF then CR since that means the first byte following a
                   LF is another line ending (CR). */
                if iByte eq 13 /*CR*/ and iPrevByte eq 10 /*LF*/ then
                    assign mlHeadersRead = true.
                            
                assign iPrevByte = iByte.
            end. /* byte loop */
            
            /* start on the next (non-CR character) */
            assign iStartByte = iLoop + 1
                   miChunkBytesRemaining = 0
                   miChunkSize = 0.
            moChunk:Clear().                   
        end.
        
        /* no else since we may have enough data to deal with all of this */
        /* followed by payload */
        if mlHeadersRead then
        do:
            case Response:TransferEncoding:
                when TransferEncodingEnum:Chunked:Name then
                do:
                    /** From http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6.1, the
                        HTTP Server returns chunked data in the following format: 
                           Chunked-Body   = *chunk
                                            last-chunk
                                            trailer
                                            CRLF
                    
                           chunk          = chunk-size [ chunk-extension ] CRLF
                                            chunk-data CRLF
                           chunk-size     = 1*HEX
                           last-chunk     = 1*("0") [ chunk-extension ] CRLF
                    **/
                    BYTE-LOOP:
                    do iLoop = iStartByte to iBytesRead:
                        assign iByte     = oSocketArgs:Data:GetByte(iLoop)
                               iNumBytes = iNumBytes + 1.
                        
                        /* if we're at the end of our incoming chunk of data, or we have hit 
                           the carriage return, cache the data until we actually have
                           jit the line end */
                           
                           /* we only care about line endings for the case where we 
                              need to figure out the chunk size (ie miChunkSize eq 0).
                              
                              for other data we keep on collecting until we know we 
                              have it all (miChunkBytesRemaining eq 0). for the latter 
                              cases, we need to treat CR and LF as data, not terminators */
                                                      
                        /* we have all the data or are at the beginning */
                        if miChunkBytesRemaining eq 0 then
                        do:
                            /* don't count the CR/LF as bytes for calculating the
                               chunk size. */
                            if iByte eq 13 or iByte eq 10 then
                                assign iNumBytes = iNumBytes - 1.
                            
                            /* gather data */
                            if ((iPrevByte eq 13 /*CR*/ and iByte eq 10 /*LF*/) or
                                 /* end of input data */
                                 iLoop eq iBytesRead) and iNumBytes gt 0 then
                                /* this data does not contain CR+LF */
                                moChunk:PutBytes(
                                            oSocketArgs:Data:GetBytes(iLoop - (iNumBytes + 1), iNumBytes)).
                            
                            /* figure out how big the chunk is */
                            if iByte eq 10 /* LF */ and iNumBytes gt 0 then
                            do:
                                assign cValue       = moChunk:GetString(1, moChunk:Size)
                                       /* we dont care about the chunk-extension */
                                       cValue       = entry(1, cValue, ';':u)
                                       miChunkSize = MathUtil:HexToInt(cValue)
                                       miChunkBytesRemaining = miChunkSize
                                       /* data chunk starts at the next byte */
                                       iStartByte = iLoop + 1.
                                /* done with this stuff */
                                moChunk:Clear().
                                
                                /* Per http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6.1 ,
                                   a chunk-size of 0 indicates the end of the data */
                                oSocketArgs:ReadComplete = (miChunkSize eq 0).
                                
                                if oSocketArgs:ReadComplete then
                                    leave BYTE-LOOP.
                            end.    /* process a new chunk size */
                        end.    /* start new chunk */
                        
                        /* add the chunk - or parts thereof - to the body */
                        if (miChunkSize gt 0 and miChunkBytesRemaining gt 0) or
                           /* end of input data */
                           iLoop eq iBytesRead then
                        do:
                            /* either get the rest of the data from the
                               input data, or the data of the chunk size */
                            assign iNumBytes = min(miChunkBytesRemaining, iBytesRead - iStartByte + 1).
                            if iNumBytes gt 0 then
                                assign oTempData = oSocketArgs:Data:GetBytes(iStartByte, iNumBytes)
                                       /* only a few more bytes to go ... */
                                       miChunkBytesRemaining = miChunkBytesRemaining - oTempData:Size
                                       /* we don't need to loop through this chunk any more. start
                                          at the first byte after the chunk */
                                       iLoop = iLoop + iNumBytes
                                       .
                            if miChunkBytesRemaining eq 0 then
                                assign /* reset the num bytes read for the chunk-size line */
                                       iNumBytes = 0.
                            
                            /* add to the main body */
                            MessageBody:PutBytes(oTempData).
                            Response:ContentLength = integer(MessageBody:Size).
                        end.
                        
                        assign iPrevByte = iByte.
                    end.    /* byte loop */
                end.    /* TransferEncodingEnum:Chunked */         
                otherwise
                do:
                    /* we know this isn't chunked data. some responses have no body,
                       so stop right here. */
                    assign oSocketArgs:ReadComplete = (Response:ContentLength eq 0).
                    if not oSocketArgs:ReadComplete then
                    do:
                        if iBytesRead eq 0 then
                            oSocketArgs:ReadComplete = true.                                
                        else
                        do:
                            /* get it all in one fell swoop (not chunked) */
                            oTempData = oSocketArgs:Data:GetBytes(
                                              iStartByte, 
                                              iBytesRead - iStartByte + 1).
                            
                            MessageBody:PutBytes(oTempData).
                            /* done if the ContentLength property matches the size of the data */                                
                            oSocketArgs:ReadComplete = (MessageBody:Size eq Response:ContentLength).                                
                        end.
                    end.
                end.
            end case.   /* body: iByte */
        end.    /* read body */
    end method.
    
    /** Write data to the output location
        
        @param longchar Data to write */
    method public void Write(input-output pcData as longchar):
        /* no-op */
    end method.
    
    /** Write data to/from the message

        @param handle Data to write */
    method public void Write(input phData as handle):    
        /* no-op */
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method public void Write(input-output pcData as character):    
        /* no-op */
    end method.    
    
    /** Write data to the output location 
    
        @param memptr Data to write */
    method public void Write(input pmData as memptr):
        /* no-op*/                
    end method.
    
    /**  Flushes data to the output location. What data is flushed depends on the implementation */
    method public void Flush():
        /* no-op */
    end method.
    
end class.

