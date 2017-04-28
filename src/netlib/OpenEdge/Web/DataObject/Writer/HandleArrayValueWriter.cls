/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : HandleArrayValueWriter
    Purpose     : Writes a primitive value to a IHandleArrayHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IHandleArrayHolder.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.HandleArrayHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder.
using Ccs.Common.Support.IHandleHolder.

class OpenEdge.Web.DataObject.Writer.HandleArrayValueWriter inherits ArgumentValueWriter:
    define variable moHandleWriter as ArgumentValueWriter no-undo.
    
    constructor public HandleArrayValueWriter ():
        super(get-class(IHandleArrayHolder)).
        
        assign moHandleWriter = ArgumentValueWriterBuilder:Build(get-class(IHandleHolder)):Writer.
    end constructor.
            
    method override public void Write(input pData as handle extent):
        assign this-object:Value = new HandleArrayHolder(pData).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable hData as handle extent no-undo.
        
        assign iMax = extent(pData)                
                hData = cast(this-object:Value, IHandleArrayHolder):Value.

        do iLoop = 1 to iMax:
            moHandleWriter:Open().
            moHandleWriter:Close().
        end.
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable oArray as JsonArray no-undo.
        
        case true:
            when not valid-object(pData) then
                assign this-object:Value = new HandleArrayHolder().
            
            when type-of(pData, IHandleArrayHolder) then
               this-object:Write(cast(pData, IHandleArrayHolder):Value).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.