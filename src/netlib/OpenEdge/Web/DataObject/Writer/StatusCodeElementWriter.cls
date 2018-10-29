/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : StatusCodeElementWriter
    Description : Writes message elements as a response status code
    Author(s)   : pjudge
    Created     : 2018-05-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.IInt64Holder.
using Ccs.Common.Support.IIntegerHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Logging.Logger.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Web.DataObject.MessageElement.
using OpenEdge.Web.DataObject.Writer.ResponseElementWriter.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using OpenEdge.Core.KeyValuePair.

class OpenEdge.Web.DataObject.Writer.StatusCodeElementWriter inherits ResponseElementWriter: 
    
    /** Default constructor. */
    constructor public StatusCodeElementWriter():
        super().
    end constructor.
    
    /** Constructor.
        
        @param IHttpResponse The response being written to */
    constructor public StatusCodeElementWriter(input pResponse as IHttpResponse):
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
    
    method override public void Write(input pElemValue as Progress.Lang.Object):
        case true:
            when not valid-object(pElemValue) then
                return.
            
            when type-of(pElemValue, KeyValuePair) then
                this-object:Write(cast(pElemValue, KeyValuePair):Value).
            
            when type-of(pElemValue, StatusCodeEnum) then
                assign this-object:Response:StatusCode = int64(cast(pElemValue, StatusCodeEnum)).
            
            when type-of(pElemValue, ICharacterHolder) then
                assign this-object:Response:StatusCode = integer(StatusCodeEnum:GetEnum(
                                                                    string(cast(pElemValue, ICharacterHolder):Value))).
            
            when type-of(pElemValue, ILongcharHolder) then
                assign this-object:Response:StatusCode = integer(StatusCodeEnum:GetEnum(
                                                            string(cast(pElemValue, ILongcharHolder):Value))).
            
            when type-of(pElemValue, IMemptrHolder) then
                assign this-object:Response:StatusCode = get-long(cast(pElemValue, IMemptrHolder):Value, 1).
            
            when type-of(pElemValue, IIntegerHolder) then
                    assign this-object:Response:StatusCode = cast(pElemValue, IIntegerHolder):Value.
            
            when type-of(pElemValue, IInt64Holder) then
                assign this-object:Response:StatusCode = integer(cast(pElemValue, IInt64Holder):Value). 
            
            otherwise
                Logger:Warn(substitute('Cannot convert message element type &1 to &2',
                                pElemValue:GetClass():TypeName,
                                string(ElementTypeEnum:StatusCode))).
        end case.
    end method.

end class.