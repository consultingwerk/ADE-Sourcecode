/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : LogicalArrayValueWriter
    Purpose     : Writes a primitive value to a IRowidArrayHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IRowidArrayHolder.
using OpenEdge.Core.RowidArrayHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.RowidArrayValueWriter inherits ArgumentValueWriter:
    
    constructor public RowidArrayValueWriter ():
        super(get-class(IRowidArrayHolder)).
    end constructor. 
    
    method override public void Write( input pData as rowid extent ):
        assign this-object:Value = new RowidArrayHolder(pData).
    end method.

    method override public void Write(input pData as Progress.Lang.Object):
        define variable oArray as JsonArray no-undo.
        
        case true:
            when not valid-object(pData) then
                this-object:Write(decimal(?)).
            
            when type-of(pData, JsonArray) then
                do:
                assign oArray = cast(pData, JsonArray). 
                this-object:Write(oArray:GetRowid(1, oArray:Length)).
            end.
                      
            when type-of(pData, IRowidArrayHolder) then
               this-object:Write(cast(pData, IRowidArrayHolder):Value).

            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.