/************************************************
Copyright (c) 2013, 2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : BackedTTAbstractCollection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Dec 16 16:24:45 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.Iterator.
using OpenEdge.Core.System.UnsupportedOperationError.
using Progress.Lang.Object.

class OpenEdge.Core.Collections.MapBackedCollection abstract serializable 
        implements ICollection:
    
    define protected property OwningMap  as IMap no-undo get. private set.
    define protected property OwningBuffer as handle no-undo get. private set.
    define protected property KeyField as handle no-undo get. private set.
    
    define public property Size as integer no-undo 
    get():
        return OwningMap:Size.
    end. 
    
    constructor public MapBackedCollection(poMap as IMap,phTT as handle, pcValuefield as char):
        super ().
        assign
            this-object:OwningBuffer = phTT
            this-object:KeyField = this-object:OwningBuffer:default-buffer-handle:buffer-field (pcValuefield)
            OwningMap = poMap.
    end constructor.
    
    method public logical Add(newObject as Object):
       return error new UnsupportedOperationError('Add', this-object:GetClass():TypeName).
    end method.

    method public logical AddAll( newCollection as ICollection ):
        return error new UnsupportedOperationError('AddAll', this-object:GetClass():TypeName).
    end method.
    
    method public logical AddArray(o as Object extent ):
        return error new UnsupportedOperationError('AddArray', this-object:GetClass():TypeName).    
    end method.

    method public void Clear():
        OwningMap:Clear().
    end method.
   
    method public logical IsEmpty():
        return OwningMap:IsEmpty().
    end method.
    
    /* abstract because this could be a key or value */
    method abstract public logical Contains( checkObject as Object).
    
    /* abstract because this could be a collection of keys or values */
    method abstract public logical ContainsAll(input poCollection as ICollection).
    
    /* abstract because this could be a collection of keys or values */
    method abstract public logical Remove( poOld as Object).
    
    /* abstract because this could be a collection of keys or values */
    method abstract public logical RemoveAll(poRemoveCol as ICollection).
    
    /* abstract because this could be a collection of keys or values */
    method abstract public logical RetainAll(input poRetainCollection as ICollection).
    
    /* Returns a new IIterator over the collection. */
    method public IIterator Iterator( ):    
        return new Iterator(this-object,this-object:OwningBuffer,this-object:KeyField:name).
    end method.
    
    /* ToArray should not be used with large collections
       If there is too much data the ABL will throw:  
       Attempt to update data exceeding 32000. (12371) */
    method public Object extent ToArray():
        define variable i as integer no-undo.
        define variable oObjArray as Object extent no-undo.
        define variable iterator as IIterator no-undo.
        
        if Size eq 0 then
            return oObjArray.
            
        extent(oObjarray) = Size.
        iterator = Iterator(). 
        do while iterator:hasNext():
           i = i + 1.
           oObjArray[i] = iterator:Next().  
        end.                                     
        return oObjArray.
    end method.
    
    method public void ToTable( output table-handle tt):
        tt = this-object:OwningBuffer.
    end method.
     
end class. 