/* *************************************************************************************************************************
Copyright (c) 2016, 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : DateTimeArrayValueWriter
    Purpose     : Writes a primitive value to a IDateTimeArrayHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IDateTimeArrayHolder.
using Ccs.Common.Support.IDateTimeHolder.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.DateTimeArrayHolder.
using OpenEdge.Core.DateTimeHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.Writer.DateTimeArrayValueWriter inherits ArgumentValueWriter:
    /* Since arrays are hard to dynamically extend, use a backing IList (ordered collection) to store the 
       values passed in until we Flush()/Close() the writer */
    define variable mBackingList as IList no-undo.
    
    constructor public DateTimeArrayValueWriter ():
        super(get-class(IDateTimeArrayHolder)).
        
        assign mBackingList = new List().
    end constructor.
    
    method override public void Clear():
        mBackingList:Clear().
        
        super:Clear().
    end method.
    
    method override public void Flush():
        define variable holder as datetime extent no-undo.
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
                assign holder[idx] = cast(iter:Next(), IDateTimeHolder):Value
                       idx         = idx + 1
                       .
            end.
        end.
        
        assign this-object:Value = new DateTimeArrayHolder(holder).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object extent):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        assign cnt = extent(pData).
        do loop = 1 to cnt:
            this-object:Write(pData[loop]).
        end.
    end method.
    
    method override public void Write( input pData as datetime extent ):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        assign cnt = extent(pData).
        do loop = 1 to cnt:
            mBackingList:Add(new DateTimeHolder(pData[loop])).
        end.
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        define variable unknownValue as datetime initial ? no-undo.
        
        case true:
            when not valid-object(pData) then
                mBackingList:Add(new DateTimeHolder(unknownValue)).
            
            when type-of(pData, JsonArray) then
            do:
                assign cnt = cast(pData, JsonArray):Length.
                do loop = 1 to cnt:
                    if cast(pData, JsonArray):IsNull(loop) then
                        mBackingList:Add(new DateTimeHolder(unknownValue)).
                    else
                        mBackingList:Add(new DateTimeHolder(cast(pData, JsonArray):GetDatetime((loop)))).
                end.
            end.
            
            when type-of(pData, IDateTimeArrayHolder) then
               this-object:Write(cast(pData, IDateTimeArrayHolder):Value).
            
            when type-of(pData, IDateTimeHolder) then
               mBackingList:Add(pData).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.