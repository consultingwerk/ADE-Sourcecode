/* *************************************************************************************************************************
Copyright (c) 2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : UpdateDataRequestValueWriter
    Purpose     : Writes the contents of a IGetUpdateRequest object based on other inputs
    Description : 
    Author(s)   : pjudge
    Created     : 2020-09-09
    Notes       : Creates an UpdateDataRequest from JSON
                  * JSON payload is 
                    {
                       "commitScope": null | string | int64
                       "customRequest": null | serialized-object
                    }
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.KeyValuePair.
using OpenEdge.Core.StringConstant.
using OpenEdge.Web.DataObject.Writer.JsonObjectValueWriter.
using OpenEdge.Web.DataObject.Writer.ObjectValueWriter.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using OpenEdge.Core.Json.JsonSerializer.

class OpenEdge.Web.DataObject.Writer.UpdateDataRequestValueWriter inherits ObjectValueWriter:
    // Because we don't want to introduce a hard dependency to the OpenEdge.BusinessLogic namespace into the OpenEdge.Net,
    // we soft-code the references.
    define static private property UpdateRequestType as Progress.Lang.Class no-undo get. set.
    define static private property UpdateRequestImplType as Progress.Lang.Class no-undo get. set.
    
    /* The writer to convert strings etc into JSON */
    define private variable mJsonValueWriter as JsonObjectValueWriter no-undo.
    
    /* A parser for string to convert to JSON */
    define private variable mJsonParser as ObjectModelParser no-undo.
    
    /* Static constructor */
    constructor static UpdateDataRequestValueWriter():
        assign UpdateRequestType     = Progress.Lang.Class:GetClass('Ccs.BusinessLogic.IUpdateDataRequest':u)
               UpdateRequestImplType = Progress.Lang.Class:GetClass('OpenEdge.BusinessLogic.UpdateDataRequest':u)
               no-error.
        assign error-status:error = false.
    end constructor.
    
    /* Default constructor */
    constructor public UpdateDataRequestValueWriter():
        super().
        
        // if this fails we will still have Progress.Lang.Object as the ArgumentType
        if valid-object(UpdateRequestType) then
            assign this-object:ArgumentType = UpdateRequestType.
        
        assign mJsonParser      = new ObjectModelParser()
               mJsonValueWriter = new JsonObjectValueWriter()
               .
    end constructor.
    
    method override public void Open():
        super:Open().
        
        mJsonValueWriter:Open().
    end method.
    
    method override public void Close():
        super:Close().
        mJsonValueWriter:Close().
    end method.
    
    method override public void Flush():
        mJsonValueWriter:Flush().
        // process the the whole input JSON as one thing
        assign this-object:Value = ParseFilter(cast(mJsonValueWriter:Value, JsonObject)).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable jsonData as JsonConstruct no-undo.
        define variable stringData as longchar no-undo.
        define variable kvp as KeyValuePair no-undo.
        
        case true:
            // Don't assign anything
            when not valid-object(pData) then
                return.
            
            // Simple straight assignment
            // when type-of(pData, IGetUpdateRequest) then
            when pData:GetClass():IsA(ArgumentType) then
                assign this-object:Value = pData.
            
            when type-of(pData, ICharacterHolder) then
                this-object:Write(cast(pData, ICharacterHolder):Value).
            
            when type-of(pData, ILongcharHolder)  then
                this-object:Write(cast(pData, ILongcharHolder):Value).
            
            when type-of(pData, KeyValuePair) then
            do:
                assign kvp = cast(pData, KeyValuePair).
                if     valid-object(kvp:Value)
                   and (   type-of(kvp:Value, ILongcharHolder)
                        or type-of(kvp:Value, ICharacterHolder))
                then
                do:
                    // if the input data is JSON, then we JSON-ify it
                    assign stringData = dynamic-property(pData, 'Value':u).
                    if    stringData begins StringConstant:CURLY_OPEN
                       or stringData begins '[':u
                    then
                        assign kvp:Value = mJsonParser:Parse(stringData).
                end.
                
                mJsonValueWriter:Write(kvp:Value).
            end.
            
            otherwise
                mJsonValueWriter:Write(pData).
        end case.
    end method.
    
    method override public void Write(input pData as longchar):
        if pData begins StringConstant:CURLY_OPEN then
            this-object:Write(mJsonParser:Parse(pData)).
        else
            mJsonValueWriter:Write(pData).
    end method.
    
    method override public void Write(input pData as character):
        if pData begins StringConstant:CURLY_OPEN then
            this-object:Write(mJsonParser:Parse(pData)).
        else
            mJsonValueWriter:Write(pData).
    end method.
    
    /* Parses JSON to produce a IGetUpdateRequest object.
        
       This is a reflection-based method that we want to replace at some point with the 
       strongly-typed one below 
       
       @param JsonObject Filter data encoded as JSON
       @return Progress.Lang.Object A filter based on the JSON input */
    method protected Progress.Lang.Object ParseFilter(input pValue as JsonObject):
        define variable updateRequest as Progress.Lang.Object no-undo.
        
        assign updateRequest = dynamic-cast(JsonSerializer:ToAblObject(pValue,
                                                                       UpdateRequestType,
                                                                       UpdateRequestImplType),
                                            UpdateRequestType:TypeName).
        
        return updateRequest.
    end method.
    
end class.
