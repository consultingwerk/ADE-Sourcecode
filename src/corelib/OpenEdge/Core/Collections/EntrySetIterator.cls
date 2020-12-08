/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : EntrySetIterator
    Purpose     : Iterator for entrysets
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Mon Apr 12 00:18:04 EDT 2010
    Notes       : The IMappedEntry Key Value are created in next().      
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.Iterator.
using OpenEdge.Core.Collections.MapEntry.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.EntrySetIterator inherits Iterator: 
    define protected property OwningMap as IMap no-undo get. set. 
    
    constructor public EntrySetIterator (poMap as IMap, poCol as ICollection, tt as handle,ofield as char):
        super(poCol,tt,ofield).  
        OwningMap = poMap.          
    end constructor. 
    
    method public override Object Next():
        define variable oKey as Object no-undo.
        oKey = super:Next().
        return new MapEntry(OwningMap,oKey). 
    end method.    
     
end class.
