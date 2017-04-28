/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MemptrArrayValueWriter
    Purpose     : Writes a primitive value to a IMemptrArrayHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IMemptrArrayHolder.
using OpenEdge.Core.MemptrArrayHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.MemptrArrayValueWriter inherits ArgumentValueWriter:
    
    constructor public MemptrArrayValueWriter ():
        super(get-class(IMemptrArrayHolder)).
    end constructor. 
    
    method override public void Write( input pData as memptr extent ):
        assign this-object:Value = new MemptrArrayHolder(pData).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable oArray as JsonArray no-undo.
        define variable mArray as memptr extent no-undo.
        
        case true:
            when not valid-object(pData) then
                assign this-object:Value = new MemptrArrayHolder(mArray).
            
            when type-of(pData, IMemptrArrayHolder) then
               this-object:Write(cast(pData, IMemptrArrayHolder):Value).

            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.