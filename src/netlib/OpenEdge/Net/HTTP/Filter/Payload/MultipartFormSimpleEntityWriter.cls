/************************************************
Copyright (c) 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MultipartFormSimpleEntityWriter
    Purpose     : Creates a MultipartEntity per http://tools.ietf.org/html/rfc2046 for multipart/form-data messages 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-03-22
    Notes       : * This uses the WEB-CONTEXT object when possible, for performance reasons. It will not take
                    *ANY* information (extra headers etc) from the message body. 
                  * This writer adds a Content-Disposition header (based on the form field names) and a
                    Content-Type header (text/plain or an inferred type from the file extension)
                  * Write() operations are destructive (they replace the existing
                    Entity).
                  * http://www.w3.org/Protocols/rfc1341/7_2_Multipart.html
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.String.
using OpenEdge.Logging.Logger.
using OpenEdge.Net.FileTypeRegistry.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Payload.MultipartEntityWriter.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.MessagePart.
using OpenEdge.Net.MultipartEntity.
using Progress.ApplicationServer.AdapterTypes.

class OpenEdge.Net.HTTP.Filter.Payload.MultipartFormSimpleEntityWriter inherits MultipartEntityWriter:
    
    /* Default constructor */
    constructor public MultipartFormSimpleEntityWriter():
        super().
    end constructor.
    
    /* Writes a multipart entity based on the WEB-CONTEXT, if possible.
       Ignores any data in the parts/body
       
       @param memptr The multipart message body 
       @return int64 The number of bytes written */
    method override public int64 Write(input pData as memptr):
        define variable multipartEntity as MultipartEntity no-undo.
        define variable msgPart as MessagePart no-undo.
        define variable formFields as character no-undo.
        define variable msgLoop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable fieldName as character no-undo.
        define variable partData as memptr no-undo.
        define variable hdr as HttpHeader no-undo.
        define variable partValue as character no-undo.
        define variable msgSize as int64 no-undo.
        define variable startAt as datetime no-undo.
        define variable partEntityWriter as MessageWriter no-undo.
        
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
        
        assign startAt                  = now
               msgSize                  = get-size(pData)
               multipartEntity          = new MultipartEntity()
               multipartEntity:Boundary = this-object:Boundary
               this-object:Entity       = multipartEntity
               cnt                      = num-entries(formFields)
               .
        do msgLoop = 1 to cnt
           on error undo, throw:
            // add the part
            assign msgPart   = new MessagePart()
                   fieldName = entry(msgLoop, formFields)
                   // this will either be the file name or the field value
                   partValue = web-context:get-cgi-value('FORM':u, fieldName)
                   
                   hdr       = HttpHeaderBuilder:Build('Content-Disposition':u)
                                    :Value('form-data':u)
                                    :Header
                   .
            msgPart:Headers:Put(hdr).
            
            hdr:SetParameterValue('name':u, fieldName).
            
            assign partData = web-context:get-binary-data(fieldName) no-error.
            
            // not an upload
            if get-size(partData) eq 0 then
                assign msgPart:Body        = new String(partValue)
                       msgPart:ContentType = 'text/plain':u
                       . 
            else
            do:
                hdr:SetParameterValue('fileName':u, partValue).
                
                // set Content-Type BEFORE calling the writer, since that's the key it uses
                assign msgPart:ContentType = FileTypeRegistry:Registry
                                                :Get(entry(num-entries(partValue, '.':u), partValue, '.':u)).
                Logger:Debug(substitute('Content type "&1" inferred from filename "&2" for field "&3"',
                                msgPart:ContentType, partValue, fieldName)).
                
                assign partEntityWriter = EntityWriterBuilder:Build(msgPart):Writer.
                Assert:NotNull(partEntityWriter, 'Part entity writer').
                
                /* Convert the binary stuff into 'real' objects */
                partEntityWriter:Open().
                partEntityWriter:Write(partData).
                partEntityWriter:Close().
                
                assign msgPart:Body = partEntityWriter:Entity.
            end.
            
            multipartEntity:AddPart(msgPart).
            finally:
                assign error-status:error = false.
                if get-size(partData) gt 0 then
                    set-size(partData) = 0.
            end finally.
        end.
        
        Logger:Trace(substitute('Multipart data of &1 bytes parsed in &2ms',
                           msgSize , interval(now, startAt, 'milliseconds':u))).
       
        return msgSize.
    end method.
    
end class.
