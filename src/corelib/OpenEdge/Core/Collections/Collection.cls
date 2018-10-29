/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------------
    File        : Collection
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sun Dec 16 22:41:40 EST 2007
    Notes       : 
------------------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.Collection.
using OpenEdge.Core.Collections.AbstractTTCollection.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.Collection serializable inherits AbstractTTCollection: 
   /*---------------------------------------------------------------------------
    Purpose: General collection class                                                                
    Notes:   
    --------------------------------------------------------------------------*/
     
    /* default temp-table  */ 
    define private temp-table ttCollection no-undo
      field objectref as Object
      index objidx objectref.
      
    constructor public Collection():
        super (temp-table ttCollection:handle,"objectref").
    end constructor.
    
    constructor public Collection (c as ICollection):
        super (c,temp-table ttCollection:handle, "objectref").
    end constructor.

    method public override logical Contains( checkObject as Object):
        define variable lContains as logical no-undo.
        define buffer lbCollection for ttCollection.
        
        if not valid-object(checkObject) then
            return false.
        
        /* try by-reference first */
        assign lContains = can-find(lbCollection where lbCollection.ObjectRef = checkObject). 
        for each lbCollection while lContains = false:
            assign lContains = lbCollection.ObjectRef:Equals(checkObject).
        end.
        
        return lContains.
    end method.
    
    method protected override void FindBufferUseObject (obj as Object):
        FindBufferUseObject(obj, buffer ttCollection).
    end method.
    
    method protected void FindBufferUseObject(obj as Object,
                                              buffer pbCollection for ttCollection):
        define variable itemRowid as rowid no-undo.
        
        release pbCollection.      // As Elsa said, Let it go!
        assign itemRowid = ?. 
        
        if can-find(pbCollection where pbCollection.objectref eq obj) then
            find pbCollection where pbCollection.objectref eq obj.
        if available pbCollection then 
            return.
        
        for each pbCollection
                 while itemRowid eq ?:
            if pbCollection.objectref:Equals(obj) then
                assign itemRowid = rowid(pbCollection).
        end.
        
        if not itemRowid eq ? then
            find pbCollection where rowid(pbCollection) eq itemRowid.
    end.
    
    /* Two Collections are defined to be equal if they are the same size and
       all of the elements in this collection are in the to-compare collection
       
       @param P.L.Object
       @return logical TRUE if the collections are equal. FALSE otherwise */
    method public override logical Equals(o as Object):
        define buffer lbCollection for ttCollection.
        define variable coll as ICollection no-undo.
        
        if super:Equals(o) then 
            return true.
        
        if type-of(o, ICollection) then
        do:
            assign coll = cast(o, ICollection).
            if not coll:Size eq this-object:Size then
                return false.
            
            for each lbCollection:
                if not coll:Contains(lbCollection.objectref) then
                    return false.
            end.
            return true.
        end.
        
        return false.
    end method.
     
end class.
