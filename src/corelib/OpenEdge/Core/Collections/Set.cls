/************************************************
Copyright (c) 2013,2014,2017-2018 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : Set
    Purpose     : A collection that contains no duplicate elements.
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Wed Jan 09 10:45:45 EST 2008
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.AbstractTTCollection.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.ISet.
using Progress.Lang.Object.
 
class OpenEdge.Core.Collections.Set inherits AbstractTTCollection implements ISet : 
    /* temp-table  */ 
    define private temp-table ttSet no-undo
      field objectref as Object 
      index objidx as unique primary objectref.
        
    /* Default constructor */
    constructor public Set (  ):
        super (temp-table ttSet:handle,"objectref").        
    end constructor.
    
    /* Constructor 
    
       @param ISet Initial set */
    constructor public Set (copyset as ISet):
        super (cast(copyset,ICollection),temp-table ttSet:handle,"objectref").        
    end constructor.
    
     method public override logical Contains( checkObject as Object):
        define buffer lbSet for ttSet. 
         
        if not valid-object(checkObject) then
            return false.
        
        FindBufferUseObject(checkObject, buffer lbSet).
        return (available lbSet).
    end method.
    
    method protected override void FindBufferUseObject (obj as Object):
        FindBufferUseObject(obj, buffer ttSet).
    end method.
    
    method protected void FindBufferUseObject(obj as Object,
                                              buffer pbSet for ttSet):
        define variable itemRowid as rowid no-undo.
        
        release pbSet.      // As Elsa said, Let it go!
        assign itemRowid = ?. 
        
        if can-find(pbSet where pbSet.objectref eq obj) then
            find pbSet where pbSet.objectref eq obj.
        if available pbSet then 
            return.
        
        for each pbSet
                 while itemRowid eq ?:
            if pbSet.objectref:Equals(obj) then
                assign itemRowid = rowid(pbSet).
        end.
        
        if not itemRowid eq ? then
            find pbSet where rowid(pbSet) eq itemRowid.
    end.
   
    method public override logical Add(obj as Object):
        define buffer lbSet for ttSet.
        
        Assert:NotNull(obj, 'Object to add').
        
        FindBufferUseObject(obj, buffer lbSet).
        if not avail lbSet then
            return super:Add(obj).
        else
            return false.
    end method.
    
    method public override logical AddAll(collection as ICollection):
        define variable iterator as IIterator no-undo.
        define variable anyAdded as logical   no-undo.
        
        assign iterator = collection:Iterator()
               anyAdded = false
               .
        do while iterator:HasNext():
            if this-object:Add(Iterator:Next()) then
               anyAdded = true.
        end.
        
        return anyAdded.
    end method.
    
    /* Equals if Set and every member of the specified set is contained in this set */
    method public override logical Equals(o as Object):
        define buffer btSet for ttSet.
        define variable oSet as ISet no-undo.
        
        if super:Equals(o) then 
            return true.
        if type-of(o,ISet) then
        do:
            oSet = cast(o,ISet).
            if oSet:Size = Size then
            do:
                for each btSet:
                    if not oSet:Contains(btSet.objectref) then
                        return false. 
                end.    
                return true.
            end.    
        end.
        return false.    
    end method.    
    
    method public override logical RemoveAll(collection as ICollection):
        define variable iterator   as IIterator no-undo.         
        define variable anyRemoved as logical no-undo.
        iterator = collection:Iterator().
        do while iterator:HasNext():
            if remove(iterator:Next()) then 
                anyRemoved = true. 
        end.
        return anyRemoved.
    end method.
     
end class.
