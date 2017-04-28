/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : LogicalValueWriter
    Purpose     : Writes values to a ILogicalHolder
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
using Ccs.Common.Support.ILogicalHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IPrimitiveHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.LogicalValueWriter inherits ArgumentValueWriter:
    
    constructor public LogicalValueWriter ():
        super(get-class(ILogicalHolder)).
    end constructor. 
    
    /* If expression is of type LONGCHAR or CHARACTER, it returns TRUE or FALSE depending on the 
       value in the expression and the format used. Whether or not char-expression-format is given, 
       the case-insensitive values TRUE, FALSE, YES, NO, abbreviated to 1 character, are always 
       accepted. For example, a "Y" is interpreted as TRUE. */ 
    method override public void Write( input pData as character):
        assign this-object:Value = new OpenEdge.Core.LogicalValue(logical(pData)).
    end method.

    /* Writes a longchar as a logical.
       
       If expression is of type LONGCHAR or CHARACTER, it returns TRUE or FALSE depending on the 
       value in the expression and the format used. Whether or not char-expression-format is given, 
       the case-insensitive values TRUE, FALSE, YES, NO, abbreviated to 1 character, are always 
       accepted. For example, a "Y" is interpreted as TRUE.  */
    method override public void Write( input pData as longchar):
        assign this-object:Value = new OpenEdge.Core.LogicalValue(logical(pData)).
    end method.
    
    /* Writes a datetime-tz value to logical
       
       If expression is of type DECIMAL, INTEGER, INT64, DATE, DATETIME, DATTIME-TZ, or HANDLE, 
       the function returns TRUE if the value of expression is nonzero. If the value of expression 
       is 0, it returns FALSE. The second argument is ignored if present. */
    method override public void Write( input pData as datetime-tz):
        assign this-object:Value = new OpenEdge.Core.LogicalValue(logical(pData)).
    end method.

    /* Writes a handle value to logical
       
       If expression is of type DECIMAL, INTEGER, INT64, DATE, DATETIME, DATTIME-TZ, or HANDLE, 
       the function returns TRUE if the value of expression is nonzero. If the value of expression 
       is 0, it returns FALSE. The second argument is ignored if present. */
    method override public void Write(input pData as handle):
        assign this-object:Value = new OpenEdge.Core.LogicalValue(logical(pData)).
    end method.

    /* Writes a decimal value to logical
       
       If expression is of type DECIMAL, INTEGER, INT64, DATE, DATETIME, DATTIME-TZ, or HANDLE, 
       the function returns TRUE if the value of expression is nonzero. If the value of expression 
       is 0, it returns FALSE. The second argument is ignored if present. */
    method override public void Write( input pData as decimal):
        assign this-object:Value = new OpenEdge.Core.LogicalValue(logical(pData)).
    end method.

    method override public void Write( input pData as logical):
        assign this-object:Value = new OpenEdge.Core.LogicalValue(pData).
    end method.

    /* Writes an int64 value to logical
       
       If expression is of type DECIMAL, INTEGER, INT64, DATE, DATETIME, DATTIME-TZ, or HANDLE, 
       the function returns TRUE if the value of expression is nonzero. If the value of expression 
       is 0, it returns FALSE. The second argument is ignored if present. */
    method override public void Write( input pData as int64):
        assign this-object:Value = new OpenEdge.Core.LogicalValue(logical(pData)).
    end method.
        
    method override public void Write(input pData as Progress.Lang.Object):
        case true:
            when not valid-object(pData) then
                assign this-object:Value = new OpenEdge.Core.LogicalValue(?).
                
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
          
            when type-of(pData, ILogicalHolder) then
               this-object:Write(cast(pData, ILogicalHolder):Value).
            
            /* Data types such as RAW, MEMPTR, LVARBINARY, and so on return the 
               Unknown value (?), but this is not considered an error. */
            when type-of(pData, IPrimitiveHolder) then
                assign this-object:Value = new OpenEdge.Core.LogicalValue(?).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.