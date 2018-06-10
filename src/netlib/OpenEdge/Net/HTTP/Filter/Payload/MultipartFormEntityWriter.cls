/************************************************
Copyright (c) 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MultipartFormEntityWriter
    Purpose     : Creates a MultipartEntity per http://tools.ietf.org/html/rfc2046 for multipart/form-data messages 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-03-22
    Notes       : * This uses the WEB-CONTEXT object when possible, for performance reasons.
                  * This writer will read/use any headers that are in the message parts. The 
                    OpenEdge.Net.HTTP.Filter.Payload.MultipartFormSimpleEntityWriter is the fastest parser and
                    does NOT read any part headers.
                  * Write() operations are destructive (they replace the existing
                    Entity).    
                  * http://www.w3.org/Protocols/rfc1341/7_2_Multipart.html
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.String.
using OpenEdge.Core.StringConstant.
using OpenEdge.Logging.Logger.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Payload.MultipartEntityWriter.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.MessagePart.
using OpenEdge.Net.MultipartEntity.
using Progress.ApplicationServer.AdapterTypes.
using Progress.Lang.AppError.

class OpenEdge.Net.HTTP.Filter.Payload.MultipartFormEntityWriter inherits MultipartEntityWriter:
    
    /* Default constructor */
    constructor public MultipartFormEntityWriter():
        super().
    end constructor.
    
    /* Writes a multipart entity based on the WEB-CONTEXT, if possible;
       includes any headers in the body. 
       
       @param memptr The multipart message body 
       @return int64 The number of bytes written */
    method override public int64 Write(input pData as memptr):
        define variable mpEntity as MultipartEntity no-undo.
        define variable msgPart as MessagePart no-undo.
        define variable msgLoop as int64 no-undo.
        define variable msgSize as int64 no-undo.
        define variable curByte as integer no-undo.
        define variable prevByte as integer no-undo.
        define variable partNum as integer no-undo.
        define variable startPos as int64 no-undo.
        define variable partLoop as int64 no-undo.
        define variable numBytes as int64 no-undo.
        define variable msgPartWriter as MessageWriter no-undo.
        define variable partData as memptr no-undo.
        define variable headersRead as logical no-undo.
        define variable msgPartData as ByteBucket no-undo.
        define variable startAt as datetime no-undo.
        define variable fileUploadDirectory as character no-undo.
        define variable formFields as character no-undo.
        define variable uploadFileName as character no-undo.
        define variable fieldName as character no-undo.
        define variable partValue as character no-undo.
        define variable appError as Progress.Lang.Error no-undo.
        define variable dispositionHdr as HttpHeader no-undo.
        define variable testBoundary as character no-undo.
        define variable boundaryLength as integer no-undo.
        define variable headerString as character no-undo.
        define variable chrPos as integer no-undo.
        define variable hdrName as character no-undo.
        define variable hdrValue as character no-undo.
        
        // The WEB-CONTEXT information is only sometimes available        
        case session:client-type:
            when 'MULTI-SESSION-AGENT':u then
            do:
                if not session:current-request-info:AdapterType eq AdapterTypes:WEB then
                    // we don't have the info we need and need to manually parse
                    return super:Write(pData).
                
                // we must have this as a non-zero value in order to process files
                if integer(web-context:get-config-value('binaryUploadMaxSize':u)) eq 0 then
                do:
                    logger:Warn('The AppServer.Agent[.abl-app-name].binaryUploadMaxSize property is 0/zero or not set; the byte-by-byte parsing method will be used').
                    return super:Write(pData).
                end.
                
                // otherwise use this implementation here
            end.
            when 'WEBSPEED':u then
                // use this implementation here
                .
            otherwise
                // we don't have the info we need and need to manually parse
                return super:Write(pData).
        end case.
        
        // the list of fields that the request knows about, CSV
        assign formFields = web-context:get-cgi-list('FORM':u).
        // If the WEB-CONTEXT doesn't know about form fields, do the manual parsing :(        
        if String:IsNullOrEmpty(formFields) then
        do:
            logger:Warn('Cannot determine form fields from the request; the byte-by-byte parsing method will be used').
            return super:Write(pData).
        end.
        
        assign mpEntity           = new MultipartEntity()
               mpEntity:Boundary  = this-object:Boundary
               this-object:Entity = mpEntity
               boundaryLength     = length(this-object:Boundary, 'raw':u)
               /* postition of first byte of part, excluding boundaries */
               startPos           = 1
               partNum            = 0
               headersRead        = false
               msgPartData        = ByteBucket:Instance()
               msgSize            = get-size(pData)
               startAt            = now
               .
        
        Assert:IsZeroOrPositive(msgSize, 'Data size').
        
        MAIN-LOOP:
        do msgLoop = 1 to msgSize:
            assign curByte = get-byte(pData, msgLoop).
            
                /* double hyphen/dash -- or end-of-data */
            if (curByte eq 45 and prevByte eq 45) or
               (msgLoop ge msgSize) then
            do:
                assign testBoundary = get-string(pData, msgLoop + 1, boundaryLength).
                if testBoundary eq this-object:Boundary then
                do:
                    /* postition of last byte of part, excluding boundaries */
                    assign startPos    = msgLoop + boundaryLength + 2 /* for CRLF */ + 1    /* +1 for next char */
                           headersRead = false
                           msgPartWriter  = ?
                           .
                    if partNum eq 0 then
                        // from startpos=1 to the char preceding the --
                        assign mpEntity:Prologue = get-string(pData, 1, max(0, (msgLoop - 2 /* for the -- */ - 2 /* for CRLF */))).
                    
                    assign msgPart  = new MessagePart()
                           prevByte = 0
                           numBytes = 0
                           .
                    // msgLoop forward to get the part headers and data
                    PART-LOOP:
                    do partLoop = startPos to msgSize:
                        assign curByte  = get-byte(pData, partLoop)
                               numBytes = numBytes + 1
                               .
                        if not headersRead then
                        do:
                            /* don't count the CR/LF as bytes */
                            if curByte eq 13 or curByte eq 10 then
                                assign numBytes = numBytes - 1.
                            
                            /* if we're at the end of our chunk of data, or we have hit 
                               the carriage return */
                            if (    (prevByte eq 13 /*CR*/ and curByte eq 10 /*LF*/ ) 
                                 or partLoop eq msgSize ) 
                               and numBytes gt 0
                            then
                            do:
                                // start at the beginning of this word/token
                                assign headerString = get-string(pData, partLoop - (numBytes + 1), numBytes)
                                       chrPos       = index(headerString, ':':u)
                                       hdrName      = trim(substring(headerString, 1, chrPos - 1))
                                       hdrValue     = trim(substring(headerString, chrPos + 1))
                                       // reset counters/temps
                                       headerString = '':u
                                       numBytes     = 0
                                       .
                                msgPart:Headers:Put(HttpHeaderBuilder:Build(hdrName):Value(hdrValue):Header).
                            end.
                            
                            /* if this is the 2nd CRLF then we have finished all the headers 
                               
                               NOTE: usually we check for line ending by having CR+LF. Here we
                               check for LF then CR since that means the first byte following a
                               LF is another line ending (CR). */
                            if     curByte eq 10 and numBytes eq 0 
                               and get-string(pData, partLoop - 3 /* 1-based counting */, 4) eq (StringConstant:CRLF + StringConstant:CRLF) 
                           then
                                assign headersRead  = true.
                        end. /* headers not yet read */
                        else
                        if headersRead then
                        do on error undo, throw:
                            // once we've read the headers, determine whether this is a (binary) file. 
                            assign dispositionHdr = msgPart:Headers:Get('Content-Disposition':u)
                                   fieldName      = trim(dispositionHdr:GetParameterValue('name':u), StringConstant:DOUBLE_QUOTE)
                                   .
                            // this form field is not available
                            if index(formFields, fieldName) eq 0 then
                            do:
                                assign appError = new AppError(substitute('Form field &1 not available as FORM value (in &2)', fieldName, formFields), 0). 
                                logger:Error('Multipart parsing error', appError).
                                undo, throw appError.
                            end.
                            
                            // this will either be the file name or the f   ield value
                            assign partValue = web-context:get-cgi-value('FORM':u, fieldName)
                                   partData  = web-context:get-binary-data(fieldName) 
                                   // if this is NOT binary/file data then it gives a runtime error
                                   no-error.
                            // separate line needed, else it's always 0 
                            assign numBytes = get-size(partData).
                            // normal text
                            if numBytes eq 0 then
                            do:
                                msgPartData:PutString(partValue).
                                assign numBytes = length(partValue, 'raw':u)
                                       msgLoop  = msgLoop + numBytes + 2    /* CRLF */
                                       .
                                logger:Trace(substitute('&1 character bytes read for field "&2"', numBytes, fieldName)).
                            end.
                            else
                            // files
                            do:
                                logger:Trace(substitute('&1 binary bytes read for field "&2"', numBytes, fieldName)).
                                msgPartData:PutBytes(get-pointer-value(partData), numBytes).
                                assign msgLoop = msgLoop + numBytes + 2.    /* CRLF */ 
                            end.
                            
                            assign msgPartWriter = EntityWriterBuilder:Build(msgPart):Writer.
                            Assert:NotNull(msgPartWriter, 'Part writer').
                            
                            /* create the entity */
                            msgPartWriter:Open().
                            msgPartWriter:Write(msgPartData).
                            msgPartWriter:Close().
                            
                            assign msgPart:Body = msgPartWriter:Entity.
                            
                            /* Only add the part to the entity once done, with success. */
                            mpEntity:AddPart(msgPart).
                            
                            leave PART-LOOP.
                            finally:
                                set-size(partData) = 0.
                                msgPartData:Clear().
                            end finally.
                        end.    /* now read the data! */
                        
                        assign prevByte = curByte.
                    end.    /* PART-LOOP: */
                    
                    /* if this is the last boundary, mark it as such */
                    if get-string(pData, startPos, 2) eq '--':u then
                    do:
                        if msgSize ge (startPos + 4) then
                            assign mpEntity:Epilogue = get-string(pData, startPos + 4 /* CRLF-- */).
                        
                        if mpEntity:Epilogue eq StringConstant:CRLF then
                            assign mpEntity:Epilogue = '':u.
                        
                        /* so we leave processing */
                        assign msgLoop = msgSize.
                        leave MAIN-LOOP.
                    end.
                    else
                        assign partNum = partNum + 1.
                end. /* we're at a boundary */
            end.    /* MAIN-LOOP: */
            
            assign prevByte = curByte.
        end.
        
        Logger:Trace(substitute('Multipart data of &1 bytes parsed in &2ms',
                            msgSize, interval(now, startAt, 'milliseconds':u))).
        
        return msgSize.
    end method.
    
end class.
