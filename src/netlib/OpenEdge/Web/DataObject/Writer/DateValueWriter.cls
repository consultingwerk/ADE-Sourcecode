/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : DateValueWriter
    Purpose     : Writes values to a IDateHolder holder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-06-29
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDateHolder.
using Ccs.Common.Support.IDateTimeHolder.
using Ccs.Common.Support.IDateTimeTzHolder.
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.DateValueWriter inherits ArgumentValueWriter:
    
    constructor public DateValueWriter ():
        super(get-class(IDateHolder)).
    end constructor. 

    method override public void Write(input pData as character):
        assign this-object:Value = new OpenEdge.Core.DateHolder(pData).
    end method.

    method override public void Write(input pData as longchar):
        this-object:Write(string(pData)).
    end method.
    
    method override public void Write(input pData as date):
        assign this-object:Value = new OpenEdge.Core.DateHolder(pData).
    end method.

    method override public void Write(input pData as datetime):
        assign this-object:Value = new OpenEdge.Core.DateHolder(date(pData)).
    end method.

    method override public void Write(input pData as datetime-tz):
        assign this-object:Value = new OpenEdge.Core.DateHolder(date(pData)).
    end method.
        
    method override public void Write(input pData as Progress.Lang.Object):
        case true:
            when not valid-object(pData) then
                this-object:Write(date('?':u)).
                
            when type-of(pData, ILongcharHolder) then
               this-object:Write(cast(pData, ILongcharHolder):Value).

            when type-of(pData, IDateHolder) then
               this-object:Write(cast(pData, IDateHolder):Value).
               
            when type-of(pData, IDateTimeHolder) then
               this-object:Write(cast(pData, IDateTimeHolder):Value).

            when type-of(pData, IDateTimeTzHolder) then
               this-object:Write(cast(pData, IDateTimeTzHolder):Value).
               
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.