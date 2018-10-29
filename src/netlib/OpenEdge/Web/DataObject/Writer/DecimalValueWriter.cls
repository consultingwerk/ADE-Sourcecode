/* *************************************************************************************************************************
Copyright (c) 2016, 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : DecimalValueWriter
    Purpose     : Writer for primitive values to a IDecimalHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-06-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDateTimeTzHolder.
using Ccs.Common.Support.IDecimalHolder.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.IInt64Holder.
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.DecimalValueWriter inherits ArgumentValueWriter:
    
    constructor public DecimalValueWriter ():
        super(get-class(IDecimalHolder)).
    end constructor. 
    
    method override public void Write(input pData as character):
        assign this-object:Value = new OpenEdge.Core.Decimal(decimal(pData)).
    end method.

    method override public void Write(input pData as longchar):
        assign this-object:Value = new OpenEdge.Core.Decimal(decimal(pData)).
    end method.
    
    method override public void Write(input pData as date):
        assign this-object:Value = new OpenEdge.Core.Decimal(decimal(pData)).
    end method.

    method override public void Write(input pData as decimal):
        assign this-object:Value = new OpenEdge.Core.Decimal(pData).
    end method.

    method override public void Write(input pData as logical):
        assign this-object:Value = new OpenEdge.Core.Decimal(decimal(pData)).
    end method.

    method override public void Write(input pData as int64):
        assign this-object:Value = new OpenEdge.Core.Decimal(decimal(pData)).
    end method.

    method override public void Write(input pData as integer):
        assign this-object:Value = new OpenEdge.Core.Decimal(decimal(pData)).
    end method.
        
    method override public void Write(input pData as Progress.Lang.Object):
        case true:
            when not valid-object(pData) then
                assign this-object:Value = new OpenEdge.Core.Decimal(?).
            
            when type-of(pData, ILongcharHolder) then
               this-object:Write(cast(pData, ILongcharHolder):Value).

            when type-of(pData, IDateTimeTzHolder) then
               this-object:Write(cast(pData, IDateTimeTzHolder):Value).
               
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