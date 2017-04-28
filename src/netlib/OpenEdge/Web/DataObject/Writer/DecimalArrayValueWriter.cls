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

using Ccs.Common.Support.IDecimalArrayHolder.
using OpenEdge.Core.DecimalArrayHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.DecimalArrayValueWriter inherits ArgumentValueWriter:
    
    constructor public DecimalArrayValueWriter ():
        super(get-class(IDecimalArrayHolder)).
    end constructor. 
    
    method override public void Write( input pData as decimal extent ):
        assign this-object:Value = new DecimalArrayHolder(pData).
    end method.

    method override public void Write(input pData as Progress.Lang.Object):
        define variable oArray as JsonArray no-undo.
        
        case true:
            when not valid-object(pData) then
                this-object:Write(decimal(?)).
            
            when type-of(pData, JsonArray) then
                do:
                assign oArray = cast(pData, JsonArray). 
                this-object:Write(oArray:GetDecimal(1, oArray:Length)).
            end.
                      
            when type-of(pData, IDecimalArrayHolder) then
               this-object:Write(cast(pData, IDecimalArrayHolder):Value).

            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.