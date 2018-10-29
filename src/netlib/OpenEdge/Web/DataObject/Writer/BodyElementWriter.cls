/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : BodyElementWriter
    Description : Writes message elements as a cookie
    Author(s)   : pjudge
    Created     : 2018-05-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Logging.Logger.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Web.DataObject.MessageElement.
using OpenEdge.Web.DataObject.Writer.ResponseElementWriter.
using Progress.IO.FileInputStream.
using OpenEdge.Core.KeyValuePair.

class OpenEdge.Web.DataObject.Writer.BodyElementWriter inherits ResponseElementWriter: 
    
    /** Default constructor. */
    constructor public BodyElementWriter():
        super().
    end constructor.
    
    /** Constructor.
        
        @param IHttpResponse The response being written to */
    constructor public BodyElementWriter(input pResponse as IHttpResponse):
        super(pResponse).
    end constructor.
    
    /* Writes message element data to the response
       
       @param character The element name 
       @param Progress.Lang.Object The data to write */
    method override public void Write(input pElemName as character,
                                      input pElemValue as Progress.Lang.Object):
        // we don't care about the name
        this-object:Write(pElemValue).
    end method.
    
    method override public void Write(input pElemValue as Progress.Lang.Object ):
        define variable hdr as HttpHeader no-undo.
        define variable fileName as character no-undo.
        define variable chrPos as integer no-undo.
        
        if not valid-object(pElemValue) then
            return.
        
        // we don't care about the name
        if type-of(pElemValue , KeyValuePair) then
            // it may be easier to do this inline, but using the approrpiate method gives us a little cover in case there's
            // changes made in the Write(name, value) method.
            this-object:Write(cast(pElemValue, KeyValuePair):Key:ToString(), cast(pElemValue, KeyValuePair):Value).
        
        if valid-object(this-object:Response:Entity) then
            Logger:Warn(substitute('Response entity &1 &2 overwritten by &3',
                            this-object:Response:Entity:GetClass():TypeName,
                            int64(this-object:Response:Entity),
                            pElemValue:GetClass():TypeName )).
        
        assign this-object:Response:Entity = pElemValue.
        
        if valid-object(pElemValue) then
        case true:
            // If we know this is a file, and we know the file name, be nice and return it to the caller
            when type-of(pElemValue, FileInputStream) then
            do:
                if not this-object:Response:HasHeader('Content-Disposition':u) then
                do:
                    assign hdr = HttpHeaderBuilder:Build('Content-Disposition':u):Header.
                    this-object:Response:SetHeader(hdr).
                end.
                else
                    assign hdr = this-object:Response:GetHeader('Content-Disposition':u).
                
                // Good info on Content-Disposition at https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Disposition
                if not hdr:GetBaseValue() eq 'inline' then
                do:
                    assign fileName = replace(cast(pElemValue, FileInputStream):FileName, StringConstant:BACKSLASH, '/':u)
                           chrPos   = r-index(fileName, '/':u)
                           fileName = substring(fileName, chrPos + 1)
                           .
                    hdr:SetParameterValue('filename':u, fileName).
                    logger:Trace(substitute('Setting Content-Disposition: fileName to &1', fileName)).
                end.
            end.    //file-input-stream
        end case.            
    end method.

end class.