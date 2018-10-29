/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : JsonObjectValueWriter
    Purpose     : Writes values into an JsonObject
    Description : 
    Author(s)   : pjudge
    Created     : 2018-04-20
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Payload.JsonEntityWriter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.JsonObjectValueWriter inherits ArgumentValueWriter:
    constructor public JsonObjectValueWriter():
        super(get-class(JsonObject)).
    end constructor.
    
    method override public void Clear():
        assign this-object:Value = new JsonObject().
    end method.
    
    method override public void Open():
        /* If nothing's passed in, use a JsonObject of our own. 
           Don't do this in the constructor as a micro-optimisation (yes, I know) */
        if not valid-object(this-object:Value) then
            assign this-object:Value = new JsonObject().
        
        super:Open().
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable jew as JsonEntityWriter no-undo.
        
        case true:
            when not valid-object(pData) then
                return.
            
            when type-of(pData, JsonArray) then
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
            
            when type-of(pData, JsonObject) then
                assign this-object:Value = pData.
            
            otherwise
            do:
                assign jew        = new JsonEntityWriter() 
                       jew:Entity = this-object:Value
                       .
                jew:Write(pData).
                
                assign this-object:Value = jew:Entity.
            end.
        end case.
    end method.
    
end class.