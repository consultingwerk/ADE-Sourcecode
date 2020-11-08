/* *************************************************************************************************************************
Copyright (c) 2018-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : FieldElementWriter
    Description : Writes message elements as a cookie
    Author(s)   : pjudge
    Created     : 2018-05-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.KeyValuePair.
using OpenEdge.Core.StringConstant.
using OpenEdge.Logging.Logger.
using OpenEdge.Net.FileTypeRegistry.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.ISupportMultipartEntity.
using OpenEdge.Net.MessagePart.
using OpenEdge.Net.MimeTypeHelper.
using OpenEdge.Web.DataObject.Writer.ResponseElementWriter.
using Progress.IO.FileInputStream.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Lang.AppError.
using OpenEdge.Core.String.

class OpenEdge.Web.DataObject.Writer.FieldElementWriter inherits ResponseElementWriter: 
    /** Default constructor. */
    constructor public FieldElementWriter():
        super().
    end constructor.
    
    /** Constructor.
        
        @param IHttpResponse The response being written to */
    constructor public FieldElementWriter(input pResponse as IHttpResponse):
        super(pResponse).
    end constructor.
    
    /* Writes message element data to the response
       
       @param character The element name 
       @param Progress.Lang.Object The data to write */
    method override public void Write(input pElemName as character,
                                      input pElemValue as Progress.Lang.Object):
        define variable msgPart as MessagePart no-undo.
        define variable entityWriter as MessageWriter no-undo.
        define variable hdr as HttpHeader no-undo.
        define variable fileName as character no-undo.
        define variable fileExt as character no-undo.
        define variable chrPos as integer no-undo.
        define variable contentType as character no-undo.
        
        // determine the field value; mainly for array values
        assign entityWriter = EntityWriterBuilder:Build(this-object:Response:ContentType):Writer.
        if not valid-object(entityWriter) then
        do:
            Logger:Warn(substitute('Cannot determine entity entityWriter for &1',this-object:Response:ContentType)).
            return.
        end.
        
        // reuse existing entity for the new field (if it has one)
        if valid-object(this-object:Response:Entity) then
            assign entityWriter:Entity = this-object:Response:Entity.
        
        entityWriter:Open().
        
        case true:
            when MimeTypeHelper:IsMultipart(this-object:Response:ContentType) then
            do:
                // stick default content-type
                assign msgPart = new MessagePart('text/plain':u, pElemValue)
                       hdr     = HttpHeaderBuilder:Build('Content-Disposition':u)
                                    :Value('form-data':u)
                                    :AddParameter('name':u, pElemName)  
                                    :Header
                       .
                msgPart:Headers:Put(hdr).
                case true:
                    when not valid-object(pElemValue)       then assign contentType = 'text/plain':u.
                    when type-of(pElemValue, JsonConstruct) then assign contentType = 'application/json':u.
                    when type-of(pElemValue, IMemptrHolder) then assign contentType = 'application/octet-stream':u.
                    // default data-structures (TT or PDS) to JSON
                    when type-of(pElemValue, IHandleHolder) then assign contentType = 'application/json':u.
                    when type-of(pElemValue, FileInputStream) then
                    do:
                        // Good info on Content-Disposition at https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Disposition
                        assign fileName = replace(cast(pElemValue, FileInputStream):FileName, StringConstant:BACKSLASH, '/':u)
                               chrPos   = r-index(fileName, '/':u)
                               fileName = substring(fileName, chrPos + 1)
                               fileExt  = entry(num-entries(fileName, '.':u), fileName, '.':u)
                               .
                        hdr:SetParameterValue('filename':u, fileName).
                        Logger:Trace(substitute('Setting Content-Disposition: fileName to &1', fileName)).
                        
                        assign contentType = FileTypeRegistry:Registry:Get(fileExt).
                        if contentType eq ? then
                            assign contentType = 'application/octet-stream':u
                                   // if we don't know the MIME type of the file, treat it as an attachment
                                   // per https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types#applicationoctet-stream
                                   hdr:Value   = 'attachment':u
                                   .
                    end.    //file-input-stream
                    // default for message parts
                    otherwise assign contentType = 'text/plain':u.
                end case.
                
                assign msgPart:ContentType = contentType.
                
                entityWriter:Write(msgPart).
                
                this-object:Response:GetHeader('Content-Type':u)
                                :SetParameterValue('boundary':u,
                                                   cast(entityWriter:Entity, ISupportMultipartEntity):Boundary 
                                ). 
            end.    /* multipart */
            
            when MimeTypeHelper:IsFormEncoded(this-object:Response:ContentType) or
            when MimeTypeHelper:IsJson(this-object:Response:ContentType) then
                entityWriter:Write(new KeyValuePair(new String(pElemName), pElemValue)).
            
            otherwise
                Logger:Warn(substitute('Unsupported MIME type &1 for field &2',
                                this-object:Response:ContentType,
                                pElemName)).
        end case.
        
        entityWriter:Close().
        
        assign this-object:Response:Entity = entityWriter:Entity.
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object ):
        case true:
            when not valid-object(pData) then
                return.
            
            when type-of(pData, KeyValuePair) then
                this-object:Write(cast(pData, KeyValuePair):Key:ToString(), cast(pData, KeyValuePair):Value).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.
end class.