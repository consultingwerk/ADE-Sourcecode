/* *************************************************************************************************************************
Copyright (c) 2016, 2018by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : LogicalArrayValueWriter
    Purpose     : Writes a primitive value to a ILogicalArrayHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILogicalArrayHolder.
using Ccs.Common.Support.ILogicalHolder.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.LogicalArrayHolder.
using OpenEdge.Core.LogicalValue.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.LogicalArrayValueWriter inherits ArgumentValueWriter:
    /* Since arrays are hard to dynamically extend, use a backing IList (ordered collection) to store the 
       values passed in until we Flush()/Close() the writer */
    define variable mBackingList as IList no-undo.
    
    constructor public LogicalArrayValueWriter ():
        super(get-class(ILogicalArrayHolder)).
        
        assign mBackingList = new List().
    end constructor. 
    
    method override public void Clear():
        mBackingList:Clear().
        
        super:Clear().
    end method.
    
    method override public void Flush():
        define variable holder as logical extent no-undo.
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
                assign holder[idx] = cast(iter:Next(), ILogicalHolder):Value
                       idx         = idx + 1
                       .
            end.
        end.
        
        assign this-object:Value = new LogicalArrayHolder(holder).
    end method.
    
    method override public void Write( input pData as logical):
        mBackingList:Add(new LogicalValue(pData)).
    end method.
    
    method override public void Write( input pData as logical extent):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        assign cnt = extent(pData).
        do loop = 1 to cnt:
            mBackingList:Add(new LogicalValue(pData[loop])).
        end.
    end method.

    method override public void Write(input pData as Progress.Lang.Object extent):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        assign cnt = extent(pData).
        do loop = 1 to cnt:
            this-object:Write(pData[loop]).
        end.
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        
        case true:
            when not valid-object(pData) then
                mBackingList:Add(new LogicalValue(?)).
            
            when type-of(pData, JsonArray) then
            do:
                assign cnt = cast(pData, JsonArray):Length.
                do loop = 1 to cnt:
                    if cast(pData, JsonArray):IsNull(loop) then
                        mBackingList:Add(new LogicalValue(?)).
                    else
                        mBackingList:Add(new LogicalValue(cast(pData, JsonArray):GetLogical(loop))).
                end.
            end.
            
            when type-of(pData, ILogicalArrayHolder) then
               this-object:Write(cast(pData, ILogicalArrayHolder):Value).
            
            when type-of(pData, ILogicalHolder) then
                mBackingList:Add(pData).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.