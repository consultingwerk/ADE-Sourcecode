/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : JsonArrayValueWriter
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

class OpenEdge.Web.DataObject.Writer.JsonArrayValueWriter inherits ArgumentValueWriter:
    constructor public JsonArrayValueWriter():
        super(get-class(JsonArray)).
    end constructor.
    
    method override public void Clear():
        assign this-object:Value = new JsonArray().
    end method.
    
    method override public void Open():
        /* If nothing's passed in, use a JsonObject of our own. 
           Don't do this in the constructor as a micro-optimisation (yes, I know) */
        if not valid-object(this-object:Value) then
            assign this-object:Value = new JsonArray().
        
        super:Open().
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object extent):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        assign cnt = extent(pData).
        do loop = 1 to cnt:
            this-object:Write(pData[loop]).
        end.
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable jew as JsonEntityWriter no-undo.
        
        case true:
            when not valid-object(pData) then
                return.
            
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