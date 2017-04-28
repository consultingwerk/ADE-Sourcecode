/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : IntegerValueWriter
    Purpose     : Writes a primitive value to a IInt64Holder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-06-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDecimalHolder.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.IInt64Holder.
using Ccs.Common.Support.ILogicalHolder.
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Lang.AppError.
using Progress.Lang.Enum.

class OpenEdge.Web.DataObject.Writer.IntegerValueWriter inherits ArgumentValueWriter:
    
    constructor public IntegerValueWriter ():
        super(get-class(IInt64Holder)).
    end constructor. 
    
    method override public void Write(input pData as character):
        assign this-object:Value = new OpenEdge.Core.Integer(int64(pData)).
    end method.

    method override public void Write( input pData as longchar):
        assign this-object:Value = new OpenEdge.Core.Integer(int64(pData)).
    end method.
    
    method override public void Write(input pData as handle):
        assign this-object:Value = new OpenEdge.Core.Integer(int64(pData)).
    end method.

    method override public void Write( input pData as decimal):
        assign this-object:Value = new OpenEdge.Core.Integer(int64(pData)).
    end method.

    method override public void Write( input pData as logical):
        assign this-object:Value = new OpenEdge.Core.Integer(int64(pData)).
    end method.
    
    method override public void Write( input pData as int64):
        assign this-object:Value = new OpenEdge.Core.Integer(pData).
    end method.

    method override public void Write( input pData as integer):
        assign this-object:Value = new OpenEdge.Core.Integer(pData).
    end method.

    method override public void Write( input pData as memptr):
        assign this-object:Value = new OpenEdge.Core.Integer(get-int64(pData, 1)).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        Assert:NotNull(pData, 'Input data'). 
        
        case true:
            when type-of(pData, Enum) then
               this-object:Write(int64(pData)).
            
            when type-of(pData, ILongcharHolder) then
               this-object:Write(cast(pData, ILongcharHolder):Value).

            when type-of(pData, ILogicalHolder) then
               this-object:Write(cast(pData, ILogicalHolder):Value).

            when type-of(pData, IHandleHolder) then
               this-object:Write(cast(pData, IHandleHolder):Value).

            when type-of(pData, IDecimalHolder) then
               this-object:Write(cast(pData, IDecimalHolder):Value).

            when type-of(pData, IInt64Holder) then
               this-object:Write(cast(pData, IInt64Holder):Value).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.