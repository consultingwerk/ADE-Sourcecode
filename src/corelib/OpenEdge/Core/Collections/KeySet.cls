/** ****************************************************************************
  Copyright 2012 Progress Software Corporation
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
    http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
**************************************************************************** **/
 /*------------------------------------------------------------------------
    File        : KeySet
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : apr 2010
    Notes       : no empty constructor, specialized for KeySet of IMap 
                 - Changes to the map are reflected here, and vice-versa. 
                 - Supports removal and removes the corresponding map entry from the map
                   (Iterator.remove, Collection.remove, removeAll, retainAll and clear) .
                 - Do not support add and addAll.   
                 - no empty constructor, specialised for IMap 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IMap. 
using OpenEdge.Core.Collections.IIterator. 
using OpenEdge.Core.Collections.ISet. 
using OpenEdge.Core.Collections.KeySet. 
using OpenEdge.Core.Collections.MapBackedCollection. 
using Progress.Lang.Object.
 
class OpenEdge.Core.Collections.KeySet serializable inherits MapBackedCollection
        implements ISet: 
  
    constructor public KeySet (poMap as IMap,phTT as handle,pcKeyField as char):
        super (poMap,phTT,pcKeyField).        
    end constructor.
    
    method public override logical Contains(poObj as Object):        
         return OwningMap:ContainsKey(poObj).
    end method.
   
    method override public logical ContainsAll(collection as ICollection):
        return OwningMap:ContainsAllKeys(collection).
    end method.
    
    /* Equals if Set and every member of the specified set is contained in this set */
    method public override logical Equals(o as Object):
        define variable oSet as ISet no-undo.
        define variable oIter as IIterator no-undo.
        if super:Equals(o) then 
            return true.
        if type-of(o,ISet) then
        do:
            oSet = cast(o,ISet).
            if oSet:Size = Size then
            do:
                oIter = Iterator().
                do while oIter:HasNext():
                    if oSet:Contains(oIter:Next()) = false then
                        return false. 
                end.    
                return true.
            end.    
        end.
        return false.    
    end method.   
     
    method public override logical Remove(poOld as Object ):
        define variable i as integer no-undo.
         /* OwningMap:Remove() returns oldvalue, but it could be unknown, so use size to check if deleted */
         i = Size.
         OwningMap:Remove(poOld).
         if i > Size then 
             return true.
         return false.    
    end method.
    
    method public override logical RemoveAll(collection as ICollection):
        define variable iterator   as IIterator no-undo.         
        define variable anyRemoved as logical no-undo.
        iterator = collection:Iterator().
        do while iterator:HasNext():
            if Remove(iterator:Next()) then 
                anyRemoved = true. 
        end.
        return anyRemoved.
    end method.
    
    method public override logical RetainAll(collection as ICollection):
        define variable iterator   as IIterator no-undo.    
        define variable oObj      as Object no-undo.     
        define variable anyRemoved as logical no-undo.
        iterator = collection:Iterator().
        do while iterator:HasNext():
            oObj = iterator:Next().
            if not Contains(oObj) then
            do:
                Remove(oObj). 
                anyRemoved = true. 
            end.
        end.
        return anyRemoved.
    end method.
     
end class.
