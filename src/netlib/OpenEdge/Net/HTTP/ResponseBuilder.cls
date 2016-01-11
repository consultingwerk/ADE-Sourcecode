 /*------------------------------------------------------------------------
    File        : ResponseBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 10 14:50:10 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.
  
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.Util.MathUtil.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.HTTP.TransferEncodingEnum.

class OpenEdge.Net.HTTP.ResponseBuilder:
     
    constructor public ResponseBuilder():
    end constructor.
    
    destructor ResponseBuilder():
        this-object:Destroy().
    end method.
    
    method public void Initialize():
    end method.
    
    method public void Destroy():
    end method.

    /** Parses the entire document returned.
        Per the HTTP 1.1 spec at http://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html#sec6,
        it has the following format.
        
        Response      = Status-Line               ; Section 6.1
                       *(( general-header        ; Section 4.5
                        | response-header        ; Section 6.2
                        | entity-header ) CRLF)  ; Section 7.1
                       CRLF
                       [ message-body ]          ; Section 7.2
        
        @return HttpResponse An immutable object containing the response.                       
    */
    method static public HttpResponse Build(input poHttpRequest as HttpRequest,
                                            input poData as ByteBucket):
        define variable oHttpResponse as HttpResponse no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iByte as integer no-undo.
        define variable iStartByte as integer no-undo.
        define variable iPrevByte as integer no-undo.
        define variable lIsStatusLine as logical no-undo.
        define variable lIsHeaders as logical no-undo.
        define variable iNumBytes as integer no-undo.
        define variable cValue as character no-undo.
        define variable cName as character no-undo.
        define variable iEntityStartPos as integer no-undo.
        define variable iMessageBodyWritePos as integer no-undo.
        define variable iChunkSize as integer no-undo.
        define variable iContentLength as integer no-undo.
        define variable oTempData as class Memptr no-undo. 
        
        assign oHttpResponse = HttpResponse:Instance(poHttpRequest)
        
               iMax = poData:Size
               iByte = ?
               iPrevByte = ?
               iEntityStartPos = 0
               iMessageBodyWritePos = 1
               iContentLength = 0.

    if session:debug-alert then
        copy-lob poData:GetBytes():Value to file session:temp-dir + 'response-raw.txt'.
        
        /* we know that the first 14 character are a fixed format per the HTTP spec.
        
           Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF
                SP = space
                HTTP-Version   = "HTTP" "/" 1*DIGIT "." 1*DIGIT
                Status-Code    = 3*DIGIT
                Reason-Phrase  = *<TEXT, excluding CR, LF>
        */
        assign oHttpResponse:Version  = poData:GetString(1, 8)
               oHttpResponse:StatusCode = 
                    StatusCodeEnum:EnumFromValue(integer(poData:GetString(10, 3)))
                lIsStatusLine = true
                lIsHeaders = false
                iStartByte = 14.
        
        /* There's another response following this complete one ... */
        if oHttpResponse:StatusCode:Equals(StatusCodeEnum:Continue) then
        do iLoop = iStartByte to iMax:
            assign iByte     = poData:GetByte(iLoop)
                   iNumBytes = iNumBytes + 1.
            
            /* this CRLF with 0 bytes is the 2nd one */
            if iPrevByte eq 13 /*CR*/ and iByte eq 10 /*LF*/ then
            do:
                /* 2 bytes = 13 + 10 */
                if iNumBytes eq 2 then
                do:
                    assign iStartByte = iLoop + 1 
                           oHttpResponse:Version  = poData:GetString(iStartByte, 8)
                                        /* start pos 
                                           + 8 bytes: version                                        
                                           + 1 byte: space */
                           iStartByte = iStartByte + 8 + 1
                           oHttpResponse:StatusCode = 
                                StatusCodeEnum:EnumFromValue(integer(poData:GetString(iStartByte, 3)))
                                        /* start pos 
                                           + 3 bytes: code                                        
                                           + 1 byte: space */
                           iStartByte = iStartByte + 3 + 1. 
                    leave.
                end.
                iNumBytes = 0.
            end.
            
            assign iPrevByte = iByte.
        end.
        
        DATA-LOOP:
        do iLoop = iStartByte to iMax:
            assign iByte = poData:GetByte(iLoop)
                   iNumBytes = iNumBytes + 1.
            
            case true:
                when lIsStatusLine then
                    case iByte:
                        when 10 /*LF*/ then
                            assign oHttpResponse:StatusReason = 
                                        poData:GetString(
                                            /* start at the beginning of this word/token */
                                            iLoop - iNumBytes + 1, 
                                            /* exclude both the LF and the preceeding CR */
                                            iNumBytes - 2).
                    end case. /* status line: iByte */
                when lIsHeaders then
                /* now each line is its own header */
                    case iByte:
                        when 58 /*COLON*/ then
                        do:
                            /* the first colon splits name/value. there may be 
                               colons in the value */
                            if cName eq '' then
                                assign cName = poData:GetString(
                                                    iLoop - iNumBytes + 1,
                                                    /* remove colon */
                                                    iNumBytes - 1)
                                       iNumBytes = 0.
                        end.    /* COLON */
                        when 13 /*CR*/ then
                            /* don't count the CR/LF characters as bytes */
                            iNumBytes = iNumBytes - 1.
                        when 10 /*LF*/ then
                        do:
                            /* don't count the CR/LF characters as bytes */
                            iNumBytes = iNumBytes - 1.
                            
                            /* num bytes will be zero after we've processed all headers */
                            if iNumBytes gt 0 then
                            do:
                                cValue = poData:GetString(
                                            /* start at the beginning of this word/token */
                                            iLoop - (iNumBytes + 2 /* CRLF */) + 1, 
                                            /* exclude both the LF and the preceeding CR */
                                            iNumBytes).
                                oHttpResponse:AddHeader(cName, left-trim(cValue)).
                            end.
                        end.    /* LF */
                    end case.   /* headers: iByte */
                otherwise /* body */
                do:
                    /* Create a copy of the response data from the HTResponse/HTChunk data. We
                       have to create at least this copy, since we don't know when the W3C 
                       library will clean up. */                       
                    case oHttpResponse:TransferEncoding:
                        when TransferEncodingEnum:Chunked then
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
                        case iByte:
                            when 10 /*LF*/ then
                            do:
                                if iPrevByte eq 13 then
                                do:
                                    cValue = poData:GetString(
                                                /* start at the beginning of this word/token */
                                                iLoop - iNumBytes + 1, 
                                                /* exclude both the LF and the preceeding CR */
                                                iNumBytes - 2 /* CRLF*/ ).
                                    iChunkSize = MathUtil:HexToInt(cValue).
                                    
                                    /* Per http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6.1 ,
                                       a chuink-size of 0 indicates the end of the data */
                                    if iChunkSize eq 0 then
                                    do:
                                        oHttpResponse:ContentLength = iContentLength.
                                        leave DATA-LOOP.
                                    end.
                                    
                                    assign iContentLength = iContentLength + iChunkSize
                                           oTempData = poData:GetBytes(
                                                   iLoop + 1,       /* the data starts at the next character */
                                                   iChunkSize).
                                    
                                    oHttpResponse:MessageBody:PutBytes(
                                            oTempData:GetPointerValue(), oTempData:Size).
                                    
                                    /* Jump to next chunk marker: add the size of the chunk and its trailing
                                       CRLF markers to get to the beginning of the next chunk-size. */
                                    assign iLoop                = iLoop + iChunkSize + 2 /*CRLF*/
                                           iMessageBodyWritePos = iMessageBodyWritePos + iChunkSize
                                           oTempData            = ?
                                           /* Update the ContentLength value with the size of bytes in body */
                                           oHttpResponse:ContentLength = oHttpResponse:MessageBody:Size.
                                end.
                            end.    /* LF */
                        end case.   /* chunked bytes */
                        otherwise
                        do:
                            /* get it all in one fell swoop (not chunked) */
                            oTempData = poData:GetBytes(
                                              iEntityStartPos, 
                                              poData:Size - iEntityStartPos + 1).
                            oHttpResponse:MessageBody:PutBytes(
                                            oTempData:GetPointerValue(), oTempData:Size).
                            leave DATA-LOOP.
                        end.
                    end case.   /* body: iByte */
                end.    /* otherswise/body */
            end case.   /* true */
                        
            if iPrevByte eq 13 /*CR*/ and iByte eq 10 /*LF*/ then
            do:
                /* if this is the 2nd CRLF then we have finished all the headers 
                   and will break out of this loop by setting the miEntityStartPos
                   variable to > 0 */
                if lIsHeaders and iNumBytes eq 0 then
                    assign iEntityStartPos = iLoop + 1
                           lIsHeaders = false.
                
                /* reset data values */
                assign iNumBytes = 0
                       cName  = ''
                       cValue = ''.
                
                if lIsStatusLine then
                    assign lIsHeaders = true
                           lIsStatusLine = false.
                
                if not lIsHeaders and not lIsStatusLine and iContentLength eq 0 then
                    oHttpResponse:AddMessageBody().
            end.
            
            assign iPrevByte = iByte.
        end. /* byte loop */
        
        return oHttpResponse.
        finally:
            oHttpResponse:Seal().
        end finally.
    end method.
    
    method private integer HexToInt(input pcHexValue as character):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iValue as integer no-undo.
        define variable iDigit as integer no-undo.
        
        iMax = length(pcHexValue).
        do iLoop = 1 to iMax:
            
            iDigit = integer(substring(pcHexValue, iLoop, 1)) no-error.
            if error-status:error then
                /* make sure we use either caps or lower, but no mixing */
                iDigit = asc(caps(substring(pcHexValue, iLoop, 1))) - asc('A') + 10 .
            iValue = iValue
                   + (iDigit * exp(16, iMax - iLoop )).
        end.
        return iValue.
    end method.
    
end class.