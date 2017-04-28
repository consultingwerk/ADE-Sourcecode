/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : DateTimeTzValueWriter
    Purpose     : Writes values to a IDateTimeTzHolder holder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-06-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDateTimeTzHolder.
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.DateTimeTzValueWriter inherits ArgumentValueWriter:
    
    constructor public DateTimeTzValueWriter ():
        super(get-class(IDateTimeTzHolder)).
    end constructor. 

    method override public void Write(input pData as character):
        assign this-object:Value = new OpenEdge.Core.DateTimeTzHolder(pData).
    end method.

    method override public void Write(input pData as longchar):
        this-object:Write(string(pData)).
    end method.
    
    method override public void Write(input pData as datetime-tz):
        assign this-object:Value = new OpenEdge.Core.DateTimeTzHolder(pData).
    end method.

    method override public void Write(input pData as Progress.Lang.Object):
        case true:
            when not valid-object(pData) then
                this-object:Write(datetime-tz(?)).
                
            when type-of(pData, ILongcharHolder) then
               this-object:Write(cast(pData, ILongcharHolder):Value).

            when type-of(pData, IDateTimeTzHolder) then
               this-object:Write(cast(pData, IDateTimeTzHolder):Value).
               
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.