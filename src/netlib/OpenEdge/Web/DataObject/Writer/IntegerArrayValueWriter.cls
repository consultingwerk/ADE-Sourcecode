/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : IntegerValueWriter
    Purpose     : Writes a primitive value to a IInt64Holder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IInt64ArrayHolder.
using Ccs.Common.Support.IIntegerArrayHolder.
using OpenEdge.Core.IntegerArrayHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.IntegerArrayValueWriter inherits ArgumentValueWriter:
    
    constructor public IntegerArrayValueWriter ():
        super(get-class(IInt64ArrayHolder)).
    end constructor. 
    
    method override public void Write( input pData as int64 extent ):
        assign this-object:Value = new IntegerArrayHolder(pData).
    end method.

    method override public void Write( input pData as integer extent ):
        assign this-object:Value = new IntegerArrayHolder(pData).
    end method.

    method override public void Write(input pData as Progress.Lang.Object):
        define variable oArray as JsonArray no-undo.
        
        case true:
            when not valid-object(pData) then
                assign this-object:Value = new IntegerArrayHolder().
            
            when type-of(pData, JsonArray) then
            do:
                assign oArray = cast(pData, JsonArray). 
                this-object:Write(oArray:GetInt64(1, oArray:Length)).
            end.
                      
            when type-of(pData, IInt64ArrayHolder) then
               this-object:Write(cast(pData, IInt64ArrayHolder):Value).
            
            when type-of(pData, IIntegerArrayHolder) then
               this-object:Write(cast(pData, IIntegerArrayHolder):Value).

            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.