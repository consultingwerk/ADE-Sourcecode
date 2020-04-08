/************************************************
Copyright (c) 2015-2019 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.Memptr.
using OpenEdge.Core.Util.MathUtil.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.HTTP.TransferEncodingEnum.
using OpenEdge.Net.ServerConnection.SocketReadEventArgs.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.ClientSocketResponseWriter
            implements IHttpMessageWriter:
    
    /* transient variables used to keep parts-of-a-line that span responses */
    define private variable mcCurrentLine as character no-undo.
    define private variable moChunk as ByteBucket no-undo.
    define private variable miChunkSize as int64 no-undo.
    define private variable miChunkBytesRemaining as int64 no-undo.
    define private variable mlStatusLineRead as logical no-undo.
    define private variable mlHeadersRead as logical no-undo.
    define private variable miPrevByte as integer no-undo.
    
    /* magic numbers */
    define private property CR as integer init 13 no-undo get.
    define private property LF as integer init 10 no-undo get.
    
    /* the message body, passed-in */
    define protected property MessageBody as ByteBucket no-undo get. private set.
    
    /* helper variable for the response, to avoid constant casting */
    define protected property Response as IHttpResponse no-undo get. private set.

    /* helper variable for the request, to avoid constant casting */
    define protected property Request as IHttpRequest no-undo get. private set.
    
    /** (mandatory) The message that's being written */  
    define public property Message as IHttpMessage no-undo
        get():
            return Response.
        end get.
    
    constructor public ClientSocketResponseWriter(input poMessage as IHttpResponse,
                                                  input poMessageBody as ByteBucket):
        Assert:NotNull(poMessage, 'Http Response').
        Assert:NotNull(poMessageBody, 'Message body').
        
        assign this-object:Response    = poMessage
               this-object:MessageBody = poMessageBody
               moChunk                 = ByteBucket:Instance()
               .
    end method.
    
    /**  Closes the output. See Open() */
    method public void Close():
        moChunk:Clear().
        
        assign this-object:Request = ?.
    end method.

    /** Opens the writer for output. Open/Close allows us to write the same message multiple
        times without requiring a new writer each time. */
    method public void Open():
        assign mcCurrentLine         = '':u
               miChunkSize           = 0
               miChunkBytesRemaining = 0
               mlStatusLineRead      = false
               mlHeadersRead         = false
               miPrevByte            = 0
               .
        moChunk:Clear().
        this-object:MessageBody:Clear().
    end method.
    
    /** Write data to the output location 
        
        @param Object Data to write */
    method public void Write(input poData as Object):  
        Assert:NotNull(poData).
        
        case true:
            when poData:GetClass():IsA(get-class(SocketReadEventArgs)) then
                this-object:Write(cast(poData, SocketReadEventArgs)).
            when poData:GetClass():IsA(get-class(IHttpRequest)) then
                this-object:Write(cast(poData, IHttpRequest)).
            otherwise
                /*no op*/ .
        end case.
    end.
    
    /* Specialised writer method for requests
        
       @param IHttpRequest A request to write */    
    method protected void Write(input poRequest as IHttpRequest):
        Assert:NotNull(poRequest, 'Http request').
        
        assign this-object:Request = poRequest.
    end method.
    
    /* Specialised writer method for socket read args
        
       @param SocketReadEventArgs A socket read args to write */    
    method protected void Write(input poSocketArgs as SocketReadEventArgs):
        define variable iBytesRead as int64 no-undo.
        define variable iLoop as int64 no-undo.
        define variable iByte as integer no-undo.
        define variable iStartByte as int64 no-undo.
        define variable iNumBytes as int64 no-undo.
        define variable iPos as int64 no-undo.
        define variable oTempData as class Memptr no-undo.
        define variable cName as character no-undo.
        define variable cValue as character no-undo.
        
        Assert:NotNull(poSocketArgs, 'Socket read argument').
        
        /* Parses a chunk of data that's received from the socket. May or not
            be a complete payload
            
            Per the HTTP 1.1 spec at http://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html#sec6,
            it has the following format.
            
            Response      = Status-Line              ; Section 6.1
                           *(( general-header        ; Section 4.5
                            | response-header        ; Section 6.2
                            | entity-header ) CRLF)  ; Section 7.1
                           CRLF
                           [ message-body ]          ; Section 7.2      */
        assign iBytesRead  = poSocketArgs:BytesRead
               iStartByte  = 1
               .
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
                assign iByte     = poSocketArgs:Data:GetByte(iLoop)
                       iNumBytes = iNumBytes + 1.
                /* don't count the CR/LF as bytes */
                if iByte eq CR or iByte eq LF then
                    assign iNumBytes = iNumBytes - 1.
                
                /* if we're at the end of our chunk of data, or we have hit 
                   the carriage return */
                if (miPrevByte eq CR and iByte eq LF ) or 
                   iLoop eq iBytesRead then
                    assign mlStatusLineRead = true
                           mcCurrentLine    = mcCurrentLine 
                                            + string(poSocketArgs:Data:GetString(iStartByte, iNumBytes, session:cpinternal))
                           iNumBytes = 0.
                assign miPrevByte = iByte.
            end. /* byte loop */
            
            assign iStartByte = iLoop.
            
            if mlStatusLineRead then
            do:
                /* assumption is that we're getting at least the status line in a chunk */
                assign this-object:Response:Version      = substring(mcCurrentLine, 1, 8)
                       this-object:Response:StatusCode   = integer(substring(mcCurrentLine, 10, 3))
                       this-object:Response:StatusReason = substring(mcCurrentLine, 14)
                       
                       mcCurrentLine = '':u
                       /* read the status line again? */
                       mlStatusLineRead = (not Response:StatusCode eq integer(StatusCodeEnum:Continue)).
            end.
        end. /* do while not read */
        
        /* no else since we may have enough data to deal with all of this */
        /* followed by headers */
        if not mlHeadersRead then
        do:
            do iLoop = iStartByte to iBytesRead while not mlHeadersRead:
                assign iByte     = poSocketArgs:Data:GetByte(iLoop)
                       iNumBytes = iNumBytes + 1.
                
                /* don't count the CR/LF as bytes */
                if iByte eq CR or iByte eq LF then
                    assign iNumBytes = iNumBytes - 1.
                
                /* if we're at the end of our chunk of data, or we have hit 
                   the carriage return */
                if (miPrevByte eq CR and iByte eq LF ) or 
                   iLoop eq iBytesRead then
                assign mcCurrentLine = mcCurrentLine
                                     /* start at the beginning of this word/token. */
                                     + string(poSocketArgs:Data:GetString(iLoop - (iNumBytes + 1), iNumBytes, session:cpinternal)).
                
                /* if we're at the end of the line, add the header to the response */
                if iByte eq LF and iNumBytes gt 0 then
                do:
                    assign iPos   = index(mcCurrentLine, ':':u)
                           cName  = substring(mcCurrentLine, 1, iPos - 1)
                           cValue = left-trim(substring(mcCurrentLine, iPos + 1))
                    /* reset counters/temps */
                           mcCurrentLine = '':u
                           iNumBytes     = 0.
                    Response:SetHeader(
                        HttpHeaderBuilder:Build(cName):Value(cValue):Header).
                end.
                
                /* if this is the 2nd CRLF then we have finished all the headers 
                
                   NOTE: usually we check for line ending by having CR+LF. Here we
                   check for LF then CR since that means the first byte following a
                   LF is another line ending (CR). */
                if iByte eq CR and miPrevByte eq LF then
                    assign mlHeadersRead = true.
                
                assign miPrevByte = iByte.
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
            /* HEAD requests have no bodies, so we know we're done now.
               If the caller of this writer has not set the Request via Write(IHTTPRequest)
               then the socket may end up timing out instead but it won't fail. */
            if     valid-object(this-object:Request)
               and this-object:Request:Method eq MethodEnum:HEAD:ToString()
            then
                assign poSocketArgs:ReadComplete = true.
            // if the status is 204, there will not be a Content-Length header
            // and also no content/message body, so we're all done
            // Per https://tools.ietf.org/html/rfc7230#section-3.3.2
            else if Response:StatusCode eq integer(StatusCodeEnum:NoContent) then
                assign poSocketArgs:ReadComplete = true.
            // If there's otherwise no entity/message body, then we can consider ourselves done.
            else if Response:ContentLength eq 0
                           // If there's a Content-Length header with a value of 0/zero, then we're done here. 
                    and (   Response:HasHeader('Content-Length':u) 
                            // if there's no discernable content on this response
                         or Response:ContentType   eq '':u ) 
            then
                assign poSocketArgs:ReadComplete = true.
            else
            // we have a body/entity and some content to process
            case Response:TransferEncoding:
                when string(TransferEncodingEnum:Chunked) then
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
                        assign iByte     = poSocketArgs:Data:GetByte(iLoop)
                               iNumBytes = iNumBytes + 1.
                        
                        /* if we're at the end of our incoming chunk of data, or we have hit 
                           the carriage return, cache the data until we actually have
                           hit the line end */
                           
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
                            if iByte eq CR or iByte eq LF then
                                assign iNumBytes = iNumBytes - 1.
                            
                            /* gather data */
                            if ((miPrevByte eq CR and iByte eq LF) or
                                 /* end of input data */
                                 iLoop eq iBytesRead) and 
                               iNumBytes gt 0 then
                            do:
                                /* If the few chars are CR or LF then discard those characters. */
                                assign iPos = iLoop - iNumBytes + 1.
                                if iByte eq LF or iByte eq CR then
                                    assign iPos = iPos - 1.
                                
                                if miPrevByte eq CR then
                                    assign iPos = iPos - 1.
                                
                                moChunk:PutBytes(poSocketArgs:Data:GetBytes(iPos, iNumBytes)).
                            end.
                                                                        
                            /* figure out how big the chunk is */
                            if iByte eq LF and moChunk:Size gt 0 then
                            do on error undo, throw:
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
                                poSocketArgs:ReadComplete = (miChunkSize eq 0).
                                
                                if poSocketArgs:ReadComplete then
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
                            do:
                                assign oTempData = poSocketArgs:Data:GetBytes(iStartByte, iNumBytes)
                                       /* only a few more bytes to go ... */
                                       miChunkBytesRemaining = miChunkBytesRemaining - oTempData:Size
                                       /* we don't need to loop through this chunk any more. start
                                          at the first byte after the chunk */
                                       iLoop = iLoop + iNumBytes.
                                
                                /* add to the main body */
                                MessageBody:PutBytes(oTempData).
                                Response:ContentLength = integer(MessageBody:Size).
                            end.
                            
                            if miChunkBytesRemaining eq 0 then
                                assign /* reset the num bytes read for the chunk-size line */
                                       iNumBytes = 0.
                        end.
                        
                        assign miPrevByte = iByte.
                    end.    /* byte loop */
                end.    /* TransferEncodingEnum:Chunked */
                otherwise
                do:
                    /* we know this isn't chunked data. some responses have no body,
                       so stop right here. */
                    assign poSocketArgs:ReadComplete = (iBytesRead eq 0)
                           iNumBytes                 = iBytesRead - iStartByte + 1
                           .
                    /* There may be more bytes to read, but in not in this packet/socket chunk */
                    if not poSocketArgs:ReadComplete and iNumBytes gt 0 then
                    do:
                        /* get it all in one fell swoop (not chunked) */
                        assign oTempData = poSocketArgs:Data:GetBytes(iStartByte, iNumBytes).
                        
                        MessageBody:PutBytes(oTempData).
                        /* Done if the Message Body is at least as big as the ContentLength. This is for cases like 
                           PSC00359890 where the Content-Length header was 760 and the actual body 762 (2 trailing 
                           whitespace bytes). */
                        assign poSocketArgs:ReadComplete = (MessageBody:Size ge Response:ContentLength).
                    end.
                end.    /* no Transfer-Encoding */
            end case.   /* non-HEAD */
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
