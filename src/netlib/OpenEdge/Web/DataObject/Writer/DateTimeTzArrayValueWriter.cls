/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : DateTimeTzArrayValueWriter
    Purpose     : Writes a primitive value to a IDateTimeTzArrayHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDateTimeTzArrayHolder.
using OpenEdge.Core.DateTimeTzArrayHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.DateTimeTzArrayValueWriter inherits ArgumentValueWriter:
    
    constructor public DateTimeTzArrayValueWriter ():
        super(get-class(IDateTimeTzArrayHolder)).
    end constructor. 
    
    method override public void Write( input pData as datetime-tz extent ):
        assign this-object:Value = new DateTimeTzArrayHolder(pData).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable oArray as JsonArray no-undo.
        
        case true:
            when not valid-object(pData) then
                this-object:Write(datetime-tz(?)).
            
            when type-of(pData, JsonArray) then
                do:
                assign oArray = cast(pData, JsonArray). 
                this-object:Write(oArray:GetDatetimeTZ(1, oArray:Length)).
            end.
                      
            when type-of(pData, IDateTimeTzArrayHolder) then
               this-object:Write(cast(pData, IDateTimeTzArrayHolder):Value).

            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.