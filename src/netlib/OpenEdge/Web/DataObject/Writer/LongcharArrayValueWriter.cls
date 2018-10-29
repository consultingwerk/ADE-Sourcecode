/* *************************************************************************************************************************
Copyright (c) 2016-2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : LongcharArrayValueWriter
    Purpose     : Writes a primitive value to an ILongcharArrayHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterArrayHolder.
using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.ILongcharArrayHolder.
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.LongcharArrayHolder.
using OpenEdge.Core.String.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.LongcharArrayValueWriter inherits ArgumentValueWriter:
    /* Since arrays are hard to dynamically extend, use a backing IList (ordered collection) to store the 
       values passed in until we Flush()/Close() the writer */
    define variable mBackingList as IList no-undo.
    
    constructor public LongcharArrayValueWriter ():
        super(get-class(ILongcharArrayHolder)).
        
        assign mBackingList = new List().
    end constructor.
    
    method override public void Clear():
        mBackingList:Clear().
        
        super:Clear().
    end method.
    
    method override public void Flush():
        define variable holder as longchar extent no-undo.
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
                assign holder[idx] = cast(iter:Next(), ILongcharHolder):Value
                       idx         = idx + 1
                       .
            end.
        end.
        
        assign this-object:Value = new LongcharArrayHolder(holder).
    end method.
    
    method override public void Write(input pValue as longchar):
        mBackingList:Add(new String(pValue)).
    end method.
    
    method override public void Write(input pData as character):
        mBackingList:Add(new String(pData)).
    end method.
    
    method override public void Write(input pData as character extent):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        assign cnt = extent(pData).
        do loop = 1 to cnt:
            mBackingList:Add(new String(pData[loop])).
        end.
    end method.
    
    method override public void Write(input pData as longchar extent):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        assign cnt = extent(pData).
        do loop = 1 to cnt:
            mBackingList:Add(new String(pData[loop])).
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
        define variable unknownString as character no-undo initial ?.
        
        case true:
            when not valid-object(pData) then
                mBackingList:Add(new String(unknownString)).
            
            when type-of(pData, JsonArray) then
            do:
                assign cnt = cast(pData, JsonArray):Length.
                do loop = 1 to cnt:
                    if cast(pData, JsonArray):IsNull(loop) then
                        mBackingList:Add(new String(unknownString)).
                    else
                        mBackingList:Add(new String(cast(pData, JsonArray):GetJsonText(loop))).
                end.
            end.
            
            when type-of(pData, JsonObject) then
                this-object:Write(cast(pData, JsonObject):GetJsonText()).
            
            when type-of(pData, ILongcharHolder) or
            when type-of(pData, ICharacterHolder) then
                mBackingList:Add(pData).
            
            when type-of(pData, ILongcharArrayHolder) then
                this-object:Write(cast(pData, ILongcharArrayHolder):Value).
            
            when type-of(pData, ICharacterArrayHolder) then
                this-object:Write(cast(pData, ICharacterArrayHolder):Value).
            
            otherwise
                this-object:Write(pData:ToString()).
        end case.
    end method.
    
end class.