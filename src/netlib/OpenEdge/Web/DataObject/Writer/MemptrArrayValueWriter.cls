/* *************************************************************************************************************************
Copyright (c) 2016, 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MemptrArrayValueWriter
    Purpose     : Writes a primitive value to a IMemptrArrayHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IMemptrArrayHolder.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.MemptrArrayHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Lang.AppError.
using OpenEdge.Core.Collections.IIterator.
using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Memptr.

class OpenEdge.Web.DataObject.Writer.MemptrArrayValueWriter inherits ArgumentValueWriter:
    /* Since arrays are hard to dynamically extend, use a backing IList (ordered collection) to store the 
       values passed in until we Flush()/Close() the writer */
    define variable mBackingList as IList no-undo.
    
    constructor public MemptrArrayValueWriter ():
        super(get-class(IMemptrArrayHolder)).
        
        assign mBackingList = new List().
    end constructor. 
    
    method override public void Clear():
        mBackingList:Clear().
        
        super:Clear().
    end method.
    
    method override public void Flush():
        define variable holder as memptr extent no-undo.
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
                assign holder[idx] = cast(iter:Next(), IMemptrHolder):Value
                       idx         = idx + 1
                       .
            end.
        end.
        
        assign this-object:Value = new MemptrArrayHolder(holder).
    end method.
    
    method override public void Write(input pData as memptr extent):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        assign cnt = extent(pData).
        do loop = 1 to cnt:
            mBackingList:Add(new Memptr(pData[loop])).
        end.
    end method.
    
    method override public void Write(input pData as memptr):
        mBackingList:Add(new Memptr(pData)).
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
        define variable oArray as JsonArray no-undo.
        define variable mArray as memptr extent no-undo.
        
        case true:
            when not valid-object(pData) then
                assign this-object:Value = new MemptrArrayHolder(mArray).
            
            when type-of(pData, IMemptrArrayHolder) then
               this-object:Write(cast(pData, IMemptrArrayHolder):Value).
            
            when type-of(pData, IMemptrHolder) then
                mBackingList:Add(pData).
            
            otherwise 
                return error new AppError(
                            substitute('Unsupported object type: &1', pData:GetClass():TypeName)
                            , 0).
        end case.
    end method.

end class.