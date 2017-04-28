/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : DateTimeArrayValueWriter
    Purpose     : Writes a primitive value to a IDateTimeArrayHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDateTimeArrayHolder.
using OpenEdge.Core.DateTimeArrayHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.DateTimeArrayValueWriter inherits ArgumentValueWriter:
    
    constructor public DateTimeArrayValueWriter ():
        super(get-class(IDateTimeArrayHolder)).
    end constructor. 
    
    method override public void Write( input pData as datetime extent ):
        assign this-object:Value = new DateTimeArrayHolder(pData).
    end method.


    method override public void Write(input pData as Progress.Lang.Object):
        define variable oArray as JsonArray no-undo.
        
        case true:
            when not valid-object(pData) then
                this-object:Write(datetime(?)).
            
            when type-of(pData, JsonArray) then
                do:
                assign oArray = cast(pData, JsonArray). 
                this-object:Write(oArray:GetDatetime(1, oArray:Length)).
            end.
                      
            when type-of(pData, IDateTimeArrayHolder) then
               this-object:Write(cast(pData, IDateTimeArrayHolder):Value).

            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.