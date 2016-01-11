/************************************************
Copyright (c)  2013,2014 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : Set
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Wed Jan 09 10:45:45 EST 2008
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.ISet.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.AbstractTTCollection. 
using Progress.Lang.Object.
 
class OpenEdge.Core.Collections.Set inherits AbstractTTCollection implements ISet : 
    /*------------------------------------------------------------------------------
            Purpose:                                                                        
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    /* temp-table  */ 
    define private temp-table ttSet no-undo
      field objectref as Object 
      index objidx as unique primary objectref.
        
    constructor public Set (  ):
        super (temp-table ttSet:handle,"objectref").        
    end constructor.
    
    constructor public Set (copyset as ISet):
        super (cast(copyset,ICollection),temp-table ttSet:handle,"objectref").        
    end constructor.    

    method public override logical Contains( checkObject as Object):
        define variable lContains as logical no-undo.
        
        if not valid-object(checkObject) then
            return false.
        
        /* try by-reference first */
        lContains = can-find(first ttSet where ttSet.ObjectRef = checkObject). 
        for each ttSet while lContains = false:
            lContains = ttSet.ObjectRef:Equals(checkObject).
        end.
        
        return lContains.
    end method.
       
    method protected override void FindBufferUseObject (obj as Object):
        find ttSet where ttSet.objectref eq obj no-error.
        if available ttSet then 
            return.
        
        for each ttSet:
            if ttSet.objectref:Equals(obj) then
                return.
        end.
    end.
   
    method public override logical Add(obj as Object):    
        find ttSet where ttSet.objectref = obj no-error.
        if not avail ttSet then     
            return super:add(obj).
        else
            return false.
    end method.
    
    method public override logical AddAll(collection as ICollection):
        define variable iterator as IIterator no-undo.
        define variable anyAdded as logical   no-undo.

        iterator = collection:Iterator().
        do while iterator:HasNext():
            if this-object:add(Iterator:Next()) then
               anyAdded = true.
        end.
        delete object iterator.
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
