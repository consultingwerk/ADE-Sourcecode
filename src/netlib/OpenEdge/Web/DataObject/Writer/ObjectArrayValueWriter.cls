/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ObjectArrayValueWriter
    Purpose     : Writes a primitive value to an ObjectArrayHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ObjectArrayHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.
using OpenEdge.Core.Collections.ICollection.

class OpenEdge.Web.DataObject.Writer.ObjectArrayValueWriter inherits ArgumentValueWriter:
    
    constructor public ObjectArrayValueWriter ():
        super(get-class(ObjectArrayHolder)).
    end constructor. 
    
    method override public void Write(input pData as Progress.Lang.Object extent):
        assign this-object:Value =  new ObjectArrayHolder(pData).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable oArray as JsonArray no-undo.
        
        case true:
            when not valid-object(pData) then
                assign this-object:Value = new ObjectArrayHolder().

            when type-of(pData, JsonArray) then
            do:
                assign oArray = cast(pData, JsonArray). 
                this-object:Write(oArray:GetJsonObject(1, oArray:Length)).
            end.
            
            when type-of(pData, ICollection) then
               this-object:Write(cast(pData, ICollection):ToArray()).

            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.