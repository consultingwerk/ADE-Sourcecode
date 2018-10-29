/* *************************************************************************************************************************
Copyright (c) 2016, 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using Ccs.Common.Support.IHandleHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.HandleArrayHolder.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.HandleArrayValueWriter inherits ArgumentValueWriter:
    /* Since arrays are hard to dynamically extend, use a backing IList (ordered collection) to store the 
       values passed in until we Flush()/Close() the writer */
    define variable mBackingList as IList no-undo.
    
    constructor public HandleArrayValueWriter ():
        super(get-class(IHandleArrayHolder)).
        
        assign mBackingList = new List().
    end constructor.
    
    method override public void Clear():
        mBackingList:Clear().
        
        super:Clear().
    end method.
    
    method override public void Flush():
        define variable holder as handle extent no-undo.
        define variable iter as IIterator no-undo.
        define variable idx as integer no-undo.
        
        super:Flush().
        
        if mBackingList:Size gt 0 then
        do:
            assign iter           = mBackingList:Iterator()
                   extent(holder) = mBackingList:Size
                   idx            = 1
                   .
            do while iter:HasNext():
                assign holder[idx] = cast(iter:Next(), IHandleHolder):Value
                       idx         = idx + 1
                       .
            end.
        end.
        
        assign this-object:Value = new HandleArrayHolder(holder).
    end method.
    
    method override public void Write(input pData as handle):
        mBackingList:Add(new WidgetHandle(pData)).
    end method.
    
    method override public void Write(input pData as handle extent):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        assign cnt = extent(pData).
        do loop = 1 to cnt:
            mBackingList:Add(new WidgetHandle(pData[loop])).
        end.
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object extent):
        if extent(pData) eq ? then
            return.
        
        Assert:IsType(pData, get-class(IHandleHolder)).
        mBackingList:AddArray(pData).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        case true:
            when not valid-object(pData) then
                mBackingList:Add(new WidgetHandle(?)).
            
            when type-of(pData, IHandleArrayHolder) then
               this-object:Write(cast(pData, IHandleArrayHolder):Value).
            
            when type-of(pData, IHandleHolder) then
                mBackingList:Add(pData).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.