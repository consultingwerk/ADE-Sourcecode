/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : LongcharArrayValueWriter
    Purpose     : Writes a primitive value to an ILongcharArrayHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterArrayHolder.
using Ccs.Common.Support.ILongcharArrayHolder.
using OpenEdge.Core.LongcharArrayHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.LongcharArrayValueWriter inherits ArgumentValueWriter:
    
    constructor public LongcharArrayValueWriter ():
        super(get-class(ILongcharArrayHolder)).
    end constructor. 
    
    method override public void Write( input pData as character extent ):
        assign this-object:Value = new LongcharArrayHolder(pData).
    end method.

    method override public void Write( input pData as longchar extent ):
        assign this-object:Value = new LongcharArrayHolder(pData).
    end method.

    method override public void Write(input pData as Progress.Lang.Object):

        case true:
            when not valid-object(pData) then
                assign this-object:Value = new LongcharArrayHolder().
            
            when type-of(pData, JsonArray) then
                this-object:Write(cast(pData, JsonArray):GetLongchar(1, cast(pData, JsonArray):Length)).
                      
            when type-of(pData, ILongcharArrayHolder) then
               this-object:Write(cast(pData, ILongcharArrayHolder):Value).
            
            when type-of(pData, ICharacterArrayHolder) then
               this-object:Write(cast(pData, ICharacterArrayHolder):Value).

            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.