/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------------
    File        : ValueCollection
    Purpose     : ICollection implementation over values in an IMap (also TT based) 
                  object that needs collection capabilities.. 
                  used to return Values IMap 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : 2010
    Notes       : no empty constructor, specialized for IMap 
                 - Changes to the map are reflected here, and vice-versa. 
                 - Supports removal and removes the corresponding map entry from the map
                   (Iterator.remove, Collection.remove, removeAll, retainAll and clear) .
                 - Do not support add and addAll.   
                 - no empty constructor, specialised for IMap 
----------------------------------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.Iterator.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.System.UnsupportedOperationError.
using OpenEdge.Core.Collections.MapBackedCollection.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.ValueCollection serializable inherits MapBackedCollection:
    
    constructor public ValueCollection(poMap as IMap,phTT as handle, pcValuefield as char):
        super (poMap, phTT, pcValuefield).
    end constructor.
    
    method override public logical Contains( checkObject as Object):
        return OwningMap:ContainsValue(checkObject).
    end method.
    
    method override public logical ContainsAll(input poCollection as ICollection):
        return OwningMap:ContainsAllValues(poCollection).
    end method.
    
    /* slow... use Remove on Map or Map:KeySet() instead  */
    method override public logical Remove(poOld as Object):
        define variable oIter as IIterator no-undo.
        define variable oKey as Object    no-undo.
        define variable oValue as Object    no-undo.
        
        oIter = OwningMap:KeySet:Iterator().
        do while oIter:HasNext():
            oKey = oIter:Next().
            oValue  = OwningMap:Get(oKey).
            if oValue:Equals(poOld) then
            do:
                OwningMap:Remove(oKey).
                return true.
            end.
        end.
        return false.
    end method.
    
    method override public logical RemoveAll(poRemoveCol as ICollection):
        define variable oIter as IIterator no-undo.
        define variable oKey  as Object    no-undo.
        define variable oVal  as Object    no-undo.
        define variable lany as logical no-undo.
        
        oIter = OwningMap:KeySet:Iterator().
        do while oIter:HasNext():
            oKey = oIter:Next().
            oVal  = OwningMap:Get(oKey).
            if poRemoveCol:Contains(oVal) then
            do:  
                OwningMap:Remove(oKey).
                lAny = true.
            end.    
        end.
        return lAny.
    end method.
    
    method override public logical RetainAll(poCol as ICollection):
        define variable oIter as IIterator no-undo.
        define variable oKey  as Object    no-undo.
        define variable oVal  as Object    no-undo.
        define variable lany as logical no-undo.
        oIter = OwningMap:KeySet:Iterator().
        do while oIter:HasNext():
            oKey = oIter:Next().
            oVal  = OwningMap:Get(oKey).
            if not poCol:Contains(oVal) then
            do:  
                OwningMap:Remove(oKey).
                lAny = true.
            end.    
        end.
        return lAny.
    end method.
end class.
