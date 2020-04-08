/* *************************************************************************************************************************
Copyright (c) 2016, 2018-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ObjectArrayValueWriter
    Purpose     : Writes a primitive value to an ObjectArrayHolder
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-08-01
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.IObjectArrayHolder.
using OpenEdge.Core.ObjectArrayHolder.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonArray.
using OpenEdge.Core.KeyValuePair.

class OpenEdge.Web.DataObject.Writer.ObjectArrayValueWriter inherits ArgumentValueWriter:
    /* Since arrays are hard to dynamically extend, use a backing IList (ordered collection) to store the 
       values passed in until we Flush()/Close() the writer */
    define private variable mBackingList as IList no-undo.
    
    /* Default constructor */
    constructor public ObjectArrayValueWriter():
        this-object(get-class(IObjectArrayHolder)).
    end constructor. 
    
    /* Constructor
       
       @param Progress.Lang.Class The argument type */
    constructor public ObjectArrayValueWriter(input pArgumentType as class Progress.Lang.Class):
        super(pArgumentType).
        
        assign mBackingList = new List().
    end constructor. 
    
    method override public void Clear():
        mBackingList:Clear().
        
        super:Clear().
    end method.
    
    method override public void Flush():
        super:Flush().
        
        assign this-object:Value = new ObjectArrayHolder(mBackingList:ToArray()).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object extent):
        mBackingList:AddArray(pData).
    end method.
    
    method override public void Write(input pData as Progress.Lang.Object):
        define variable oArray as JsonArray no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        define variable kvp as KeyValuePair no-undo.
        
        case true:
            when not valid-object(pData) then
            do:
                // The default collections don't allow adding null/unknown objects, so we have to 
                // do some trickery
                mBackingList:Add(new Progress.Lang.Object()).
                mBackingList:Set(mBackingList:Size, ?).
            end.
            
            when type-of(pData, KeyValuePair) then
            do:
                assign kvp = cast(pData, KeyValuePair)
                       cnt = integer(kvp:Key:ToString())
                       // We can't add past the end of the list 
                       cnt = min(cnt, mBackingList:Size) 
                       no-error.
                mBackingList:Add(cnt, kvp:Value).
                
                // clear out the error flag from above
                assign error-status:error = no. 
            end.
            
            when type-of(pData, JsonArray) then
            do:
                assign cnt = cast(pData, JsonArray):Length.
                do loop = 1 to cnt:
                    if cast(pData, JsonArray):IsNull(loop) then
                    do:
                        mBackingList:Add(new Progress.Lang.Object()).
                        mBackingList:Set(mBackingList:Size, ?).
                    end.
                    else
                        mBackingList:Add(cast(pData, JsonArray):GetJsonObject(loop)).
                end.
            end.
            
            when type-of(pData, IObjectArrayHolder) then
                mBackingList:AddArray(cast(pData, IObjectArrayHolder):Value).
            
            otherwise
                mBackingList:Add(pData).
        end case.
    end method.

end class.