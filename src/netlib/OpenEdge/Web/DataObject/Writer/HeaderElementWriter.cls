/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : HeaderElementWriter
    Description : Writes message elements as a cookie
    Author(s)   : pjudge
    Created     : 2018-05-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.IObjectArrayHolder.
using OpenEdge.Core.KeyValuePair.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using OpenEdge.Web.DataObject.MessageElement.
using OpenEdge.Web.DataObject.Writer.ResponseElementWriter.

class OpenEdge.Web.DataObject.Writer.HeaderElementWriter inherits ResponseElementWriter: 
    
    /** Default constructor. */
    constructor public HeaderElementWriter():
        super().
    end constructor.
    
    /** Constructor.
        
        @param IHttpResponse The response being written to */
    constructor public HeaderElementWriter(input pResponse as IHttpResponse):
        super(pResponse).
    end constructor.
    
    /* Writes message element data to the response
       
       The ElemName value can be either 
        - Header name like "X-OE-Client-Props", or
        - A header name + a parameter name , like "Content-Disposition; filename".
       
       In the former case, the element value is written to the header's Value property;
       in the latter, the element value is written to the header's 'filename' parameter value.
       
       @param character The element name 
       @param Progress.Lang.Object The data to write */
    method override public void Write(input pElemName as character,
                                      input pElemValue as Progress.Lang.Object):
        define variable hdrName as character no-undo.
        define variable hdrValue as character no-undo.
        define variable paramName as character no-undo.
        define variable hdr as HttpHeader no-undo.
        
        case true:
            when not valid-object(pElemValue) then
                return.
            
            when type-of(pElemValue, IObjectArrayHolder) or
            when type-of(pElemValue, HttpHeader) then
                this-object:Write(pElemValue).
            
            when type-of(pElemValue, ILongcharHolder) or
            when type-of(pElemValue, ICharacterHolder) then
            do:
                assign hdrValue = string(dynamic-property(pElemValue, 'Value':u))
                       hdrName  = entry(1, pElemName, ';':u)
                       .
                if num-entries(pElemName, ';':u) ge 2 then
                    assign paramName = entry(2, pElemName, ';':u).
                else
                    assign paramName = ?.
                
                if this-object:Response:HasHeader(hdrName) then
                    assign hdr = this-object:Response:GetHeader(hdrName).
                
                if not valid-object(hdr) then
                do:
                    assign hdr = HttpHeaderBuilder:Build(hdrName):Header.
                    this-object:Response:SetHeader(hdr).
                end.
                
                if paramName eq ? then
                    assign hdr:Value = hdrValue.
                else
                    hdr:SetParameterValue(paramName, hdrValue).
            end.
        end case.
    end method.
    
    method override public void Write(input pElemValue as Progress.Lang.Object ):
        define variable headers as Progress.Lang.Object extent no-undo.
        
        case true:
            when not valid-object(pElemValue) then
                return.
            
            when type-of(pElemValue, IObjectArrayHolder) then
            do:
                assign headers = cast(pElemValue, IObjectArrayHolder):Value.
                if extent(headers) eq ? then
                    return.
                
                Assert:IsType(headers, get-class(HttpHeader)).
                this-object:Response:SetHeaders(cast(headers, HttpHeader)).
            end.
            
            when type-of(pElemValue, KeyValuePair) then
                this-object:Write(cast(pElemValue, KeyValuePair):Key:ToString(), cast(pElemValue, KeyValuePair):Value).
            
            when type-of(pElemValue, HttpHeader) then
                this-object:Response:SetHeader(cast(pElemValue, HttpHeader)).
            
            otherwise
                Logger:Warn(substitute('Cannot convert message element type &1 to &2',
                                pElemValue:GetClass():TypeName,
                                string(ElementTypeEnum:Header))).
        end case.
    end method.

end class.