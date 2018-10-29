/************************************************
Copyright (c) 2013, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : MapEntry
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Mon Apr 12 00:24:25 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.Assert.
using Progress.Lang.Object.
 
class OpenEdge.Core.Collections.MapEntry serializable 
        implements IMapEntry: 
    
    define protected property OwningMap as IMap no-undo get. set.
    
    define public property Key as  Object no-undo 
    get.
    private set. 
    
    define public property Value as  Object no-undo
    get():
        return OwningMap:Get(this-object:Key).
    end get.            
    set(input poValue as Object):
        OwningMap:Put(this-object:Key, poValue).
    end.
    
    constructor public MapEntry (poMap as IMap, poKey as Object):
        super ().
        
        Assert:NotNull(poMap, 'Map').
        Assert:NotNull(poKey, 'Key').
        
        assign this-object:Key = poKey
               this-object:OwningMap = poMap.
    end constructor.
    
    method public override logical Equals(o as Object):
         define variable oMapEntry as IMapEntry no-undo.
         if super:Equals(o) then
             return true.
         if type-of(o,IMapEntry) then
         do: 
             oMapEntry = cast(o,IMapEntry).
             return this-object:Key:Equals(oMapEntry:Key) 
                    and 
                    this-object:Value:Equals(oMapEntry:Value).
         end.
         return false.
    end method.
    

end class.
